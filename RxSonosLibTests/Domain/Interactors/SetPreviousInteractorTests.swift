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
        XCTAssertEqual(transportRepository.nextTrackCounter.value, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter.value, 0)
        let interactor = SetPreviousTrackInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetPreviousTrackValues(group: firstGroup())
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        XCTAssertEqual(transportRepository.nextTrackCounter.value, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter.value, 1)
    }
    
    func testItCantSetThePreviousTrackWithoutVolumeValues() {
        let interactor = SetPreviousTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
