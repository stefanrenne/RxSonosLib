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
    
    internal lazy var getMusicProvidersInteractor: GetMusicProvidersInteractor = { GetMusicProvidersInteractor(musicProvidersRepository: RepositoryInjection.provideMusicProvidersRepository()) }()
    static public func getAllMusicProviders() -> Single<[MusicProvider]> {
        return shared
            .allGroups
            .filter({ $0.count > 0 })
            .take(1)
            .asSingle()
            .flatMap { (groups) -> Single<[MusicProvider]> in
                return shared.getMusicProvidersInteractor.get(values: GetMusicProvidersValues(room: groups.first?.master))
            }
    }
    
    internal lazy var getAlarmsInteractor: GetAlarmsInteractor = { GetAlarmsInteractor(alarmRepository: RepositoryInjection.provideAlarmRepository()) }()
    static public func getAllAlarms() -> Single<[Alarm]> {
        return shared.getAlarmsInteractor.get()
    }
    
    /* Group */
    internal lazy var getGroupsInteractor: GetGroupsInteractor = { GetGroupsInteractor(groupRepository: RepositoryInjection.provideGroupRepository()) }()
    private func startRenewingGroups(with rooms: [Room]) {
        guard rooms.count > 0 else { return }
        renewingGroupDisposable?.dispose()
        
        renewingGroupDisposable = createTimer(SonosSettings.shared.renewGroupsTimer)
            .flatMap({ _ -> Observable<[Group]> in
                return self.getGroupsInteractor
                    .get(values: GetGroupsValues(rooms: rooms))
                    .asObservable()
            })
            .subscribe(allGroups)
    }
    
    internal lazy var getNowPlayingInteractor: GetNowPlayingInteractor = { GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func getTrack(_ group: Group) -> Observable<Track?> {
        return shared.getNowPlayingInteractor.get(values: GetNowPlayingValues(group: group))
    }
    
    internal lazy var getGroupProgressInteractor: GetGroupProgressInteractor = { GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func getProgress(_ group: Group) -> Observable<GroupProgress> {
        return shared.getGroupProgressInteractor.get(values: GetGroupProgressValues(group: group))
    }
    
    internal lazy var getGroupQueueInteractor: GetGroupQueueInteractor = { GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository()) }()
    static public func getQueue(_ group: Group) -> Observable<[MusicProviderTrack]> {
        return shared.getGroupQueueInteractor.get(values: GetGroupQueueValues(group: group))
    }
    
    internal lazy var getTransportStateInteractor: GetTransportStateInteractor = { GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func getTransportState(_ group: Group) -> Observable<TransportState> {
        return shared.getTransportStateInteractor.get(values: GetTransportStateValues(group: group))
    }
    
    internal lazy var setTransportStateInteractor: SetTransportStateInteractor = { SetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func setTransport(state: TransportState, for group: Group) -> Completable {
        return shared.setTransportStateInteractor.get(values: SetTransportStateValues(group: group, state: state))
    }
    
    internal lazy var setNextTrackInteractor: SetNextTrackInteractor = { SetNextTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func setNextTrack(_ group: Group) -> Completable {
        return shared.setNextTrackInteractor.get(values: SetNextTrackValues(group: group))
    }
    
    internal lazy var setPreviousTrackInteractor: SetPreviousTrackInteractor = { SetPreviousTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func setPreviousTrack(_ group: Group) -> Completable {
        return shared.setPreviousTrackInteractor.get(values: SetPreviousTrackValues(group: group))
    }
    
    internal lazy var getVolumeInteractor: GetVolumeInteractor = { GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository()) }()
    static public func getVolume(_ group: Group) -> Observable<Int> {
        return shared.getVolumeInteractor.get(values: GetVolumeValues(group: group))
    }
    
    internal lazy var setVolumeInteractor: SetVolumeInteractor = { SetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository()) }()
    static public func set(volume: Int, for group: Group) -> Completable {
        return shared.setVolumeInteractor.get(values: SetVolumeValues(group: group, volume: volume))
    }
    
    /* Room */
    internal lazy var getRoomsInteractor: GetRoomsInteractor = { GetRoomsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository()) }()
    private func startRenewingRooms() {
        getRoomsInteractor
            .get()
            .do(onNext: { [weak self] (newRooms) in
                self?.getAlarmsInteractor.requestValues = GetAlarmsValues(room: newRooms.first)
            })
            .subscribe(allRooms)
            .disposed(by: disposebag)
    }
    
    internal lazy var getMuteInteractor: GetMuteInteractor = { GetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository()) }()
    static public func getMute(for room: Room) -> Observable<Bool> {
        return shared.getMuteInteractor.get(values: GetMuteValues(room: room))
    }
    
    internal lazy var setMuteInteractor: SetMuteInteractor = { SetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository()) }()
    static public func set(mute enabled: Bool, for room: Room) -> Completable {
        return shared.setMuteInteractor.get(values: SetMuteValues(room: room, enabled: enabled))
    }
    
    /* Track */
    internal lazy var getTrackImageInteractor: GetTrackImageInteractor = { GetTrackImageInteractor(transportRepository: RepositoryInjection.provideTransportRepository()) }()
    static public func getTrackImage(_ track: Track) -> Observable<Data?> {
        return shared.getTrackImageInteractor.get(values: GetTrackImageValues(track: track))
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
    
    private func setActive(group: Group?) {
        guard activeGroupValue() != group else { return }
        activeGroup.onNext(group)
    }
}
