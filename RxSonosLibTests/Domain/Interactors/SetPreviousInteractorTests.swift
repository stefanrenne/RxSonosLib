//
//  SetPreviousInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class SetPreviousInteractorTests: XCTestCase {
    
    let transportRepository: FakeTransportRepositoryImpl = FakeTransportRepositoryImpl()
    
    func testItCanSetThePreviousTrack() {
        XCTAssertEqual(transportRepository.nextTrackCounter, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter, 0)
        let interactor = SetPreviousTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertNoThrow(try interactor
            .get(values: SetPreviousTrackValues(group: firstGroup()))
            .toBlocking()
            .toArray())
        XCTAssertEqual(transportRepository.nextTrackCounter, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter, 1)
    }
    
    func testItCantSetThePreviousTrackWithoutVolumeValues() {
        let interactor = SetPreviousTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
