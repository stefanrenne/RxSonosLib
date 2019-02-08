//
//  SetTransportStateInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 14/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class SetTransportStateInteractorTests: XCTestCase {
    
    let transportRepository: FakeTransportRepositoryImpl = FakeTransportRepositoryImpl()
    
    func testItCanSetTheCurrentStateToPlay() {
        let interactor = SetTransportStateInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetTransportStateValues(group: firstGroup(), state: TransportState.playing)
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        
        XCTAssertEqual(transportRepository.activeState, TransportState.playing)
    }
    
    func testItCanSetTheCurrentStateToPaused() {
        let interactor = SetTransportStateInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetTransportStateValues(group: firstGroup(), state: TransportState.paused)
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        
        XCTAssertEqual(transportRepository.activeState, TransportState.paused)
    }
    
    func testItCanSetTheCurrentStateToStop() {
        let interactor = SetTransportStateInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetTransportStateValues(group: firstGroup(), state: TransportState.stopped)
        
        XCTAssertNoThrow(try interactor
            .get()
            .toBlocking()
            .toArray())
        
        XCTAssertEqual(transportRepository.activeState, TransportState.stopped)
    }
    
    func testItCantSetTheCurrentStateToTransitioning() {
        let interactor = SetTransportStateInteractor(transportRepository: transportRepository)
        interactor.requestValues = SetTransportStateValues(group: firstGroup(), state: TransportState.transitioning)
        
        XCTAssertThrowsError(try interactor
            .get()
            .toBlocking()
            .toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
    func testItCantSetTheCurrentStateWithoutVolumeValues() {
        let interactor = SetTransportStateInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
