//
//  GetAlarmsInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetAlarmsInteractorTests: XCTestCase {
    
    private let alarmRepository: FakeAlarmRepositoryImpl = FakeAlarmRepositoryImpl()
    
    func testItCanGetTheMusicProviders() {
        XCTAssertEqual(alarmRepository.numberListCounter.value, 0)
        let interactor = GetAlarmsInteractor(alarmRepository: alarmRepository)
        interactor.requestValues = GetAlarmsValues(room: firstRoom())
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        XCTAssertEqual(alarmRepository.numberListCounter.value, 1)
    }
    
    func testItCantGetTheMusicProvidersWithoutVolumeValues() {
        let interactor = GetAlarmsInteractor(alarmRepository: alarmRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
