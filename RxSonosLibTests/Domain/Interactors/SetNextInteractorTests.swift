//
//  SetNextInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class SetNextInteractorTests: XCTestCase {
    
    let transportRepository: FakeTransportRepositoryImpl = FakeTransportRepositoryImpl()
    
    func testItCanSetTheNextTrack() {
        XCTAssertEqual(transportRepository.nextTrackCounter, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter, 0)
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertNoThrow(try interactor
            .get(values: SetNextTrackValues(group: firstGroup()))
            .toBlocking()
            .toArray())
        XCTAssertEqual(transportRepository.nextTrackCounter, 1)
        XCTAssertEqual(transportRepository.previousTrackCounter, 0)
    }
    
    func testItCantSetTheNextTrackWithoutVolumeValues() {
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
