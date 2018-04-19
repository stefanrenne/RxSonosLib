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
   
    func testItCanGetTheCurrentState() {
        let interactor = GetTransportStateInteractor(transportRepository: transportRepository)
        let state = try! interactor.get(values: GetTransportStateValues(group: firstGroup()))
            .toBlocking(
            ).first()!
        
        XCTAssertEqual(state, TransportState.paused)
    }
    
    func testItCantGetTheCurrentStateWithoutAGroup() {
        let interactor = GetTransportStateInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}
