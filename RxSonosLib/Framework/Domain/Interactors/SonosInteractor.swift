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
    internal let allRooms: BehaviorSubject<[Room]> = BehaviorSubject(value: [])
    internal let allGroups: BehaviorSubject<[Group]> = BehaviorSubject(value: [])
    internal let activeGroup: BehaviorSubject<Group?> = BehaviorSubject(value: nil)
    internal let disposebag = DisposeBag()
    internal var renewingGroupDisposable: Disposable?
    
    init() {
        observerRooms()
        observerGroups()
        startRenewingRooms()
    }
    
    static public func setActive(group: Group) throws {
        let all = try shared.allGroups.value()
        if all.contains(group) {
            shared.setActive(group: group)
        }
    }
    
    static public func getActiveGroup() -> Observable<Group> {
        return shared
            .activeGroup
            .asObserver()
            .flatMap(ignoreNil)
    }
    
    static public func getAllGroups() -> Observable<[Group]> {
        return shared.allGroups.asObserver()
    }
    
    static public func getAllMusicProviders() -> Single<[MusicProvider]> {
        return shared
            .allGroups
            .filter({ $0.count > 0 })
            .take(1)
            .asSingle()
            .flatMap { (groups) -> Single<[MusicProvider]> in
                return GetMusicProvidersInteractor(musicProvidersRepository: RepositoryInjection.provideMusicProvidersRepository())
                    .get(values: GetMusicProvidersValues(room: groups.first?.master))
        }   
    }
    
    /* Group */
    static public func getTrack(_ group: Group) -> Observable<Track?> {
        return GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetNowPlayingValues(group: group))
    }
    
    static public func getProgress(_ group: Group) -> Observable<GroupProgress> {
        return GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetGroupProgressValues(group: group))
    }
    
    static public func getQueue(_ group: Group) -> Observable<[MusicProviderTrack]> {
        return GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
            .get(values: GetGroupQueueValues(group: group))
    }
    
    static public func getTransportState(_ group: Group) -> Observable<TransportState> {
        return GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTransportStateValues(group: group))
    }
    
    static public func setTransport(state: TransportState, for group: Group) -> Completable {
        return SetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetTransportStateValues(group: group, state: state))
    }
    
    static public func setNextTrack(_ group: Group) -> Completable {
        return SetNextTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetNextTrackValues(group: group))
    }
    
    static public func setPreviousTrack(_ group: Group) -> Completable {
        return SetPreviousTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetPreviousTrackValues(group: group))
    }
    
    static public func getVolume(_ group: Group) -> Observable<Int> {
        return GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetVolumeValues(group: group))
    }
    
    static public func set(volume: Int, for group: Group) -> Completable {
        return SetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetVolumeValues(group: group, volume: volume))
    }
    
    /* Room */
    static public func getMute(for room: Room) -> Observable<Bool> {
        return GetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetMuteValues(room: room))
    }
    
    static public func set(mute enabled: Bool, for room: Room) -> Completable {
        return SetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetMuteValues(room: room, enabled: enabled))
    }
    
    /* Track */
    static public func getTrackImage(_ track: Track) -> Observable<Data?> {
        return GetTrackImageInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTrackImageValues(track: track))
    }
    
}

extension SonosInteractor {
    private func activeGroupValue() -> Group? {
        do {
            return try activeGroup.value()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func observerRooms() {
        allRooms
            .asObserver()
            .subscribe(onNext: { [weak self] (rooms) in
                self?.startRenewingGroups(with: rooms)
            })
            .disposed(by: disposebag)
    }
    
    private func startRenewingRooms() {
        GetRoomsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository())
            .get()
            .subscribe(allRooms)
            .disposed(by: disposebag)
    }
    
    private func observerGroups() {
        allGroups
            .asObserver()
            .subscribe(onNext: { (groups) in
                guard let active = self.activeGroupValue() else {
                    self.setActive(group: groups.first)
                    return
                }
                
                if !groups.contains(active) {
                    if let firstGroupWithSameMasterRoom = groups.filter({ $0.master == active.master }).first {
                        self.setActive(group: firstGroupWithSameMasterRoom)
                        return
                    }
                    self.setActive(group: groups.first)
                    return
                }
            })
            .disposed(by: disposebag)
    }
    
    private func startRenewingGroups(with rooms: [Room]) {
        guard rooms.count > 0 else { return }
        renewingGroupDisposable?.dispose()
        
        renewingGroupDisposable = createTimer(SonosSettings.shared.renewGroupsTimer)
            .flatMap({ _ -> Observable<[Group]> in
                return GetGroupsInteractor(groupRepository: RepositoryInjection.provideGroupRepository())
                    .get(values: GetGroupsValues(rooms: rooms))
                    .asObservable()
            })
            .subscribe(allGroups)
    }
    
    private func setActive(group: Group?) {
        guard activeGroupValue() != group else { return }
        activeGroup.onNext(group)
    }
}
