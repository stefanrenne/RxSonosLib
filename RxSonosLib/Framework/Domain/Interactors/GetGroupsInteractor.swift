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
    let rooms: [Room]
}

class GetGroupsInteractor: SingleInteractor {
    
    typealias T = GetGroupsValues
    
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func buildInteractorObservable(values: GetGroupsValues?) -> Single<[Group]> {
        guard let rooms = values?.rooms else {
            return Single.error(SonosError.invalidImplementation)
        }
        
        guard rooms.count > 0 else {
            return Single.just([])
        }
        
        return groupRepository
            .getGroups(for: rooms)
    }
}
