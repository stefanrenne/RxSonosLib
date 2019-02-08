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
        XCTAssertEqual(transportRepository.nextTrackCounter.value, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter.value, 0)
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetNextTrackValues(group: firstGroup())
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        XCTAssertEqual(transportRepository.nextTrackCounter.value, 1)
        XCTAssertEqual(transportRepository.previousTrackCounter.value, 0)
    }
    
    func testItCantSetTheNextTrackWithoutVolumeValues() {
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
