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
        let stateObservable = SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap { (group) -> Observable<TransportState> in
                return SonosInteractor.getTransportState(group)
            }
        
        let serviceObservable = getActiveTrack()
            .map({ (track) -> MusicService in
                return track?.service ?? MusicService.unknown
            })
            .distinctUntilChanged()
        
        return Observable.combineLatest(stateObservable, serviceObservable, resultSelector: ({ ($0, $1) }))
    }
    
    static public func getActiveTrackImage() -> Observable<Data?> {
        return SonosInteractor
            .getActiveTrack()
            .flatMap(ignoreNil())
            .flatMap { (track) -> Observable<Data?> in
                return SonosInteractor.getTrackImage(track)
            }
    }
    
    static public func getActiveGroupProgress() -> Observable<GroupProgress> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap { (group) -> Observable<GroupProgress> in
                return GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
                    .get(values: GetGroupProgressValues(group: group))
            }
    }
    
    static public func getActiveGroupQueue() -> Observable<[Track]> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap { (group) -> Observable<[Track]> in
                return GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
                    .get(values: GetGroupQueueValues(group: group))
            }
    }
        
    static public func getActiveGroupVolume() -> Observable<Int> {
        return SonosInteractor
            .getActiveGroup()
            .flatMap(ignoreNil())
            .flatMap { (group) -> Observable<Int> in
                return GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
                    .get(values: GetVolumeValues(group: group))
            }
    }
    
    static public func setActiveGroup(volume: Int) -> Observable<Void> {
        return SonosInteractor
            .getActiveGroup()
            .take(1)
            .flatMap { (optionalGroup) -> Observable<Void> in
                guard let group = optionalGroup else {
                    throw NSError.sonosLibNoGroupError()
                }
                return SetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
                    .get(values: SetVolumeValues(group: group, volume: volume))
            }
    }
    
    /* Group */
    static public func getTrack(_ group: Group) -> Observable<Track?> {
        return GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetNowPlayingValues(group: group))
    }
    
    
    static public func getTransportState(_ group: Group) -> Observable<TransportState> {
        return GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTransportStateValues(group: group))
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
