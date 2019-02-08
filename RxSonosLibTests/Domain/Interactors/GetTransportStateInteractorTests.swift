//
//  GetTransportStateInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 28/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSwift
import RxBlocking

class GetTransportStateInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
   
    func testItCanGetTheCurrentState() throws {
        let interactor = GetTransportStateInteractor(transportRepository: transportRepository)
        interactor.requestValues = GetTransportStateValues(group: firstGroup())
        let state = try interactor
            .get()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(state, TransportState.paused)
    }
    
    func testItCantGetTheCurrentStateWithoutAGroup() {
        let interactor = GetTransportStateInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
