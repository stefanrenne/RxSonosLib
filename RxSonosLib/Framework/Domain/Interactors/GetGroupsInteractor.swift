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
    let rooms: BehaviorSubject<[Room]>
    
    init(rooms: BehaviorSubject<[Room]>) {
        self.rooms = rooms
    }
    
}

class GetGroupsInteractor: Interactor {
    
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func buildInteractorObservable(requestValues: GetGroupsValues?) -> Observable<[Group]> {
        guard let roomSubject = requestValues?.rooms else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(SonosSettings.shared.renewGroupsTimer)
            .flatMap(mapRoomsToGroups(roomSubject: roomSubject))
            .distinctUntilChanged()
    }
    
    /* Groups */
    fileprivate func mapRoomsToGroups(roomSubject: BehaviorSubject<[Room]>) -> ((Int) throws -> Observable<[Group]>) {
        return { _ in
            let rooms = (try? roomSubject.value()) ?? []
            return self.groupRepository
                .getGroups(for: rooms)
                .asObservable()
        }
    }
}
