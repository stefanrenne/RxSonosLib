//
//  FakeAlarmRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxSonosLib

class FakeAlarmRepositoryImpl: AlarmRepository {
    
    func getAlarmItems(for room: Room) -> Single<[Alarm]> {
        return Single.just([])
    }
}
