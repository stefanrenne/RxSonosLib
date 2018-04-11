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
    public let name: String
    
    /// All Room names in this group
    public let names: [String]
    
    init(master: Room, slaves: [Room]) {
        self.master = master
        self.slaves = slaves
        self.name = (slaves.count > 0) ? "\(master.name) +\(slaves.count)" : master.name
        self.names = [master.name] + slaves.map({ $0.name })
    }
    
    public func getTrack() -> Observable<Track?> {
        return SonosInteractor.getTrack(self)
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
