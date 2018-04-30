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

class GetGroupsValues: RequestValues {
    let rooms: Observable<[Room]>
    
    init(rooms: Observable<[Room]>) {
        self.rooms = rooms
    }
    
}

class GetGroupsInteractor: BaseInteractor<GetGroupsValues, [Group]> {
    
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
        
        SSDPSettings.shared.maxBufferTime = SonosSettings.shared.searchNetworkForDevices
    }
    
    override func buildInteractorObservable(requestValues: GetGroupsValues?) -> Observable<[Group]> {
        guard let roomObservable = requestValues?.rooms else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return roomObservable
            .flatMap(addTimer(SonosSettings.shared.renewGroupsTimer))
            .flatMap(mapRoomsToGroups())
            .distinctUntilChanged({ $0 == $1 })
    }
    
    /* Groups */
    fileprivate func mapRoomsToGroups() -> (([Room]) throws -> Observable<[Group]>) {
        return { rooms in
            return self.groupRepository.getGroups(for: rooms)
        }
    }
}
