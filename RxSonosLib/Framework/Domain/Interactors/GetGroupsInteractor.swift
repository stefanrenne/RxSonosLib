//
//  GetGroupsInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSSDP

open class GetGroupsValues: RequestValues {
}

open class GetGroupsInteractor: BaseInteractor<GetGroupsValues, [Group]> {
    
    let ssdpRepository: SSDPRepository
    let roomRepository: RoomRepository
    let groupRepository: GroupRepository
    
    public init(ssdpRepository: SSDPRepository, roomRepository: RoomRepository, groupRepository: GroupRepository) {
        self.ssdpRepository = ssdpRepository
        self.roomRepository = roomRepository
        self.groupRepository = groupRepository
    }
    
    override func buildInteractorObservable(requestValues: GetGroupsValues?) -> Observable<[Group]> {
        
        return ssdpRepository
            .scan(broadcastAddresses: ["239.255.255.250", "255.255.255.255"], searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1", maxTimeSpan: 3, maxCount: 100)
            .flatMap(mapSSDPToRooms())
            .flatMap(addTimer(5))
            .flatMap(mapRoomsToGroups())
            .distinctUntilChanged({ $0 == $1 })
    }
    
    /* Rooms */
    fileprivate func mapSSDPToRooms() -> (([SSDPResponse]) throws -> Observable<[Room]>) {
        return { ssdpDevices in
            let collection = ssdpDevices.compactMap(self.mapSSDPToRoom())
            return Observable.zip(collection)
        }
    }
    
    fileprivate func mapSSDPToRoom() -> ((SSDPResponse) -> Observable<Room>?) {
        return { response in
            guard let device = SSDPDevice.map(response) else { return nil }
            return self.roomRepository.getRoom(device: device)
        }
    }
    
    /* Groups */
    fileprivate func mapRoomsToGroups() -> (([Room]) throws -> Observable<[Group]>) {
        return { rooms in
            return self.groupRepository.getGroups(for: rooms)
        }
    }
}
