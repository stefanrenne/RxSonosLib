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
        return self.rooms.map({ $0.name })
    }()
    
    /// All Rooms in this group
    private var rooms: [Room] {
        return [self.master] + self.slaves
    }
    
    init(master: Room, slaves: [Room]) {
        self.master = master
        self.slaves = slaves
    }
    
}

extension Group {
    public func getTrack() -> Observable<Track?> {
        return SonosInteractor.getTrack(self)
    }
    
    public func getTransportState() -> Observable<(TransportState, MusicService)> {
        return SonosInteractor.getTransportState(self)
    }
    
    public func set(transportState: TransportState) -> Observable<TransportState> {
        return SonosInteractor.setTransport(state: transportState, for: self)
    }
    
    public func getVolume() -> Observable<Int> {
        return SonosInteractor.getVolume(self)
    }
    
    public func set(volume: Int) -> Observable<Int> {
        return SonosInteractor.set(volume: volume, for: self)
    }
    
    public func setNextTrack() -> Observable<Void> {
        return SonosInteractor.setNextTrack(self)
    }
    
    public func setPreviousTrack() -> Observable<Void> {
        return SonosInteractor.setPreviousTrack(self)
    }
    
    public func getMute() -> Observable<Bool> {
        return master.getMute()
    }
    
    public func set(mute enabled: Bool) -> Observable<Bool> {
        let collection = rooms.map { (room) -> Observable<Bool> in
            return room.set(mute: enabled)
        }
        return Observable.zip(collection).map{ _ in return enabled }
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
