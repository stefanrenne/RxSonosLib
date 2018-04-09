//
//  FakeGroupRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSwift

class FakeGroupRepositoryImpl: GroupRepository {
    
    var returnNoGroups = false
    func getGroups(for rooms: [Room]) -> Observable<[Group]> {
        if returnNoGroups {
            return Observable<[Group]>.just([])
        } else {
            let groups = rooms.filter({ !$0.hasProxy }).map({ Group(master: $0, slaves: []) })
            return Observable<[Group]>.just(groups)
        }
    }
    
}
