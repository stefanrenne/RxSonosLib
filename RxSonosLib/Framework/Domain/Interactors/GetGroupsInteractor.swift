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

struct GetGroupsValues: RequestValues {
    let rooms: BehaviorSubject<[Room]>
}

class GetGroupsInteractor: ObservableInteractor {
    
    var requestValues: GetGroupsValues?
    
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func buildInteractorObservable(values: GetGroupsValues?) -> Observable<[Group]> {
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
