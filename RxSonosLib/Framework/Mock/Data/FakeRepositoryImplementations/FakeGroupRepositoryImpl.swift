//
//  FakeGroupRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class FakeGroupRepositoryImpl: GroupRepository {
    
    func getGroups(for rooms: [Room]) -> Observable<[Group]> {
        let groups = rooms.filter({ !$0.hasProxy }).map({ Group(master: $0, slaves: []) })
        return Observable<[Group]>.just(groups)
    }
    
}
