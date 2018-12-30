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
    
    typealias T = GetGroupsValues
    
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func buildInteractorObservable(values: GetGroupsValues?) -> Observable<[Group]> {
        do {
            guard let rooms = try values?.rooms.value() else {
                throw SonosError.invalidImplementation
            }
            
            return createTimer(SonosSettings.shared.renewGroupsTimer)
                .flatMap(mapRoomsToGroups(rooms: rooms))
                .distinctUntilChanged()
        } catch {
            return Observable.error(error)
        }
    }
    
    /* Groups */
    fileprivate func mapRoomsToGroups(rooms: [Room]) -> ((Int) throws -> Observable<[Group]>) {
        return { _ in
            guard rooms.count > 0 else {
                return Observable.just([])
            }
            
            return self.groupRepository
                .getGroups(for: rooms)
                .asObservable()
        }
    }
}
