//
//  GetGroupProgressInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetGroupProgressInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
    
    func testItCanGetTheCurrentProgress() {
        let interactor = GetGroupProgressInteractor(transportRepository: transportRepository)
        let progress = try! interactor.get(values: GetGroupProgressValues(group: firstGroup()))
            .toBlocking()
            .first()!
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.timeString, "0:30")
        XCTAssertEqual(progress.duration, 60)
        XCTAssertEqual(progress.durationString, "1:00")
        XCTAssertEqual(progress.progress, 0.5)
        XCTAssertEqual(progress.remainingTimeString, "-0:30")
    }
    
    func testItCantGetTheCurrentProgressWithoutAGroup() {
        let interactor = GetGroupProgressInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
