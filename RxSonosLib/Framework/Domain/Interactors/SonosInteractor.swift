//
//  SonosInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class SonosInteractor {
    internal static let shared: SonosInteractor = SonosInteractor()
    internal let allGroups: BehaviorSubject<[Group]> = BehaviorSubject(value: [])
    internal let activeGroup: BehaviorSubject<Group?> = BehaviorSubject(value: nil)
    internal let activeTrack: BehaviorSubject<Track?> = BehaviorSubject(value: nil)
    internal let disposebag = DisposeBag()
    
    init() {
        self.observerGroups()
        self.observerActiveTrack()
    }
    
    static public func setActive(group: Group) {
        let all = try! shared.allGroups.value()
        if all.contains(group) {
            shared.setActive(group: group)
        }
    }
    
    static public func getActiveGroup() -> Observable<Group?> {
        return shared
            .activeGroup
            .asObserver()
    }
    
    static public func getAllGroups() -> Observable<[Group]> {
        return shared.allGroups.asObserver()
    }
    
    /* Active Group */
    static public func getActiveTrack() -> Observable<Track?> {
        return shared
            .activeTrack
            .asObserver()
    }
    
    static public func getActiveTransportState() -> Observable<(TransportState, MusicService)> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<(TransportState, MusicService)> in
                return SonosInteractor.getTransportState(group)
            })
            .distinctUntilChanged({ (lhs, rhs) -> Bool in
                return lhs.0 == rhs.0 && lhs.1 == rhs.1
            })
    }
    
    static public func setActiveTransport(state: TransportState) -> Observable<TransportState> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .map(requiresGroup())
            .flatMap { (group) -> Observable<TransportState> in
                return SonosInteractor.setTransport(state: state, for: group)
            }
    }
    
    static public func setActiveNextTrack() -> Observable<Void> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .map(requiresGroup())
            .flatMap { (group) -> Observable<Void> in
                return SonosInteractor.setNextTrack(group)
            }
    }
    
    static public func setActivePreviousTrack() -> Observable<Void> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .map(requiresGroup())
            .flatMap { (group) -> Observable<Void> in
                return SonosInteractor.setPreviousTrack(group)
            }
    }
    
    static public func getActiveTrackImage() -> Observable<Data?> {
        return SonosInteractor
            .getActiveTrack()
            .flatMap(ignoreNil())
            .flatMap({ (track) -> Observable<Data?> in
                return SonosInteractor.getTrackImage(track)
            })
            .distinctUntilChanged()
    }
    
    static public func getActiveGroupProgress() -> Observable<GroupProgress> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<GroupProgress> in
                return GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
                    .get(values: GetGroupProgressValues(group: group))
            })
            .distinctUntilChanged()
    }
    
    static public func getActiveGroupQueue() -> Observable<[Track]> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<[Track]> in
                return GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
                    .get(values: GetGroupQueueValues(group: group))
            })
            .distinctUntilChanged()
    }
        
    static public func getActiveGroupVolume() -> Observable<Int> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<Int> in
                return SonosInteractor.getVolume(group)
            })
            .distinctUntilChanged()
    }
    
    static public func setActiveGroup(volume: Int) -> Observable<Int> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .map(requiresGroup())
            .flatMap { (group) -> Observable<Int> in
                SonosInteractor.set(volume: volume, for: group)
            }
    }
    
    static public func setActive(mute enabled: Bool) -> Observable<Bool> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .map(requiresGroup())
            .flatMap { (group) -> Observable<Bool> in
                return group.set(mute: enabled)
        }
    }
    
    static public func getActiveMute() -> Observable<Bool> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<Bool> in
                return group.getMute()
            })
            .distinctUntilChanged()
    }
    
    /* Group */
    static public func getTrack(_ group: Group) -> Observable<Track?> {
        return GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetNowPlayingValues(group: group))
    }
    
    static public func getTransportState(_ group: Group) -> Observable<(TransportState, MusicService)> {
        let stateObservable = GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTransportStateValues(group: group))
        
        let serviceObservable = SonosInteractor
            .getTrack(group)
            .map({ (track) -> MusicService in
                return track?.service ?? MusicService.unknown
            })
            .distinctUntilChanged()
        
        return Observable.combineLatest(stateObservable, serviceObservable, resultSelector: ({ ($0, $1) }))
    }
    
    static public func setTransport(state: TransportState, for group: Group) -> Observable<TransportState> {
        return SetTransportStateInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetTransportStateValues(group: group, state: state))
            .map({ _ in return state })
    }
    
    static public func setNextTrack(_ group: Group) -> Observable<Void> {
        return SetNextTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetNextTrackValues(group: group))
    }
    
    static public func setPreviousTrack(_ group: Group) -> Observable<Void> {
        return SetPreviousTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetPreviousTrackValues(group: group))
    }
    
    static public func getVolume(_ group: Group) -> Observable<Int> {
        return GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetVolumeValues(group: group))
    }
    
    static public func set(volume: Int, for group: Group) -> Observable<Int> {
        return SetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetVolumeValues(group: group, volume: volume))
            .map({ _ in return volume })
    }
    
    /* Room */
    static public func getMute(for room: Room) -> Observable<Bool> {
        return GetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetMuteValues(room: room))
    }
    
    static public func set(mute enabled: Bool, for room: Room) -> Observable<Bool> {
        return SetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetMuteValues(room: room, enabled: enabled))
            .map({ _ in return enabled })
    }
    
    /* Track */
    static public func getTrackImage(_ track: Track) -> Observable<Data?> {
        return GetTrackImageInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTrackImageValues(track: track))
    }
    
}

extension SonosInteractor {
    private func activeGroupValue() -> Group? {
        return try! self.activeGroup.value()
    }
    
    private func observerGroups() {
        GetGroupsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository(), groupRepository: RepositoryInjection.provideGroupRepository())
            .get()
            .subscribe(self.allGroups)
            .disposed(by: disposebag)
        
        allGroups
            .asObserver()
            .subscribe(onNext: { (groups) in
                guard let active = self.activeGroupValue() else {
                    self.setActive(group: groups.first)
                    return
                }
                
                if !groups.contains(active) {
                    for group in groups {
                        if group.master == active.master {
                            self.setActive(group: group)
                            return
                        }
                    }
                    self.setActive(group: groups.first)
                    return
                }
            })
            .disposed(by: disposebag)
    }
    
    private func observerActiveTrack() {
        activeGroup
            .asObserver()
            .flatMap(ignoreNil())
            .flatMap({ (group) -> Observable<Track?> in
                return SonosInteractor.getTrack(group)
            })
            .subscribe(self.activeTrack)
            .disposed(by: disposebag)
    }
    
    private func setActive(group: Group?) {
        if self.activeGroupValue() != group {
            self.activeGroup.onNext(group)
        }
    }
}

fileprivate func ignoreNil<T>() -> ((T?) -> Observable<T>) {
    return { object in
        return object.map(Observable.just) ?? Observable.empty()
    }
}

fileprivate func requiresGroup() -> ((Group?) throws -> Group) {
    return { optionalGroup in
        guard let group = optionalGroup else {
            throw NSError.sonosLibNoGroupError()
        }
        return group
    }
}
