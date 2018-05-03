//
//  Group.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class Group {
    
    /// The Master Room handles all requests that are fired to the Sonos Group
    public let master: Room
    
    /// Only some requests are also processed by slave rooms, as example volume controll requests
    public let slaves: [Room]
    
    /// Name of the group
    public lazy var name: String = {
        return (self.slaves.count > 0) ? "\(self.master.name) +\(self.slaves.count)" : self.master.name
    }()
    
    /// All Room names in this group
    public lazy var names: [String] = {
        return Array(Set(self.rooms.map({ $0.name })))
    }()
    
    /// All Rooms in this group
    internal var rooms: [Room] {
        return [self.master] + self.slaves
    }
    
    /// Active Track for this Group
    internal let activeTrack: BehaviorSubject<Track?> = BehaviorSubject(value: nil)
    internal let disposebag = DisposeBag()
    
    init(master: Room, slaves: [Room]) {
        self.master = master
        self.slaves = slaves
        self.observerActiveTrack()
    }
    
}

extension Group: Equatable {
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        
        return lhs.master == rhs.master && lhs.slaves.sorted(by: sortRooms()) == rhs.slaves.sorted(by: sortRooms())
    }
}

fileprivate func sortRooms() -> ((Room, Room) -> Bool) {
    return { room1, room2 in
        room1.uuid > room2.uuid
    }
}

extension Group {
    private func observerActiveTrack() {
        SonosInteractor
            .getTrack(self)
            .subscribe(self.activeTrack)
            .disposed(by: self.disposebag)
    }
}

extension ObservableType where E == Group {
    public func getRooms() -> Observable<[Room]> {
        return
            self
            .map({ (group) -> [Room] in
                return group.rooms
            })
            .distinctUntilChanged()
    }
    
    public func getTrack() -> Observable<Track?> {
        return
            self
            .flatMap({ (group) -> Observable<Track?> in
                return group
                    .activeTrack
                    .asObserver()
            })
            .distinctUntilChanged()
    }
    
    public func getImage() -> Observable<Data?> {
        return
            self
            .getTrack()
            .flatMap(ignoreNil())
            .flatMap({ (track) -> Observable<Data?> in
                return Observable
                    .just(track)
                    .getImage()
            })
            .distinctUntilChanged()
    }
    
    public func getProgress() -> Observable<GroupProgress> {
        return
            self
            .flatMap({ (group) -> Observable<GroupProgress> in
                return SonosInteractor.getProgress(group)
            })
            .distinctUntilChanged()
    }
    
    public func getQueue() -> Observable<[Track]> {
        return
            self
            .flatMap({ (group) -> Observable<[Track]> in
                return SonosInteractor.getQueue(group)
            })
            .distinctUntilChanged()
    }
    
    public func getTransportState() -> Observable<(TransportState, MusicServiceType)> {
        return
            self
            .flatMap({ (group) -> Observable<(TransportState, MusicServiceType)> in
                return SonosInteractor.getTransportState(group)
            })
            .distinctUntilChanged({ (lhs, rhs) -> Bool in
                return lhs.0 == rhs.0 && lhs.1 == rhs.1
            })
    }
    
    public func set(transportState: TransportState) -> Observable<TransportState> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<TransportState> in
                return SonosInteractor.setTransport(state: transportState, for: group)
            })
    }
    
    public func getVolume() -> Observable<Int> {
        return
            self
            .flatMap({ (group) -> Observable<Int> in
                return SonosInteractor.getVolume(group)
            })
            .distinctUntilChanged()
    }
    
    public func set(volume: Int) -> Observable<Int> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<Int> in
                return SonosInteractor.set(volume: volume, for: group)
            })
    }
    
    public func setNextTrack() -> Observable<Void> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<Void> in
                return SonosInteractor.setNextTrack(group)
            })
    }
    
    public func setPreviousTrack() -> Observable<Void> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<Void> in
                return SonosInteractor.setPreviousTrack(group)
            })
    }
    
    public func getMute() -> Observable<[Bool]> {
        return
            self
            .take(1)
            .getRooms()
            .getMute()
    }
    
    public func set(mute enabled: Bool) -> Observable<[Bool]> {
        return
            self
            .take(1)
            .getRooms()
            .set(mute: enabled)
    }
}
