//
//  SonosInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class SonosInteractorTests: XCTestCase {
    
    func testItCanProvideGroupsInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupsInteractor()) == GetGroupsInteractor.self)
    }
    
    func testItCanProvideNowPlayingInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideNowPlayingInteractor()) == GetNowPlayingInteractor.self)
    }
    
    func testItCanProvideTransportStateInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideTransportStateInteractor()) == GetTransportStateInteractor.self)
    }
    
    func testItCanProvideTrackImageInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideTrackImageInteractor()) == GetTrackImageInteractor.self)
    }
    
    func testItCanProvideGroupProgressInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupProgressInteractor()) == GetGroupProgressInteractor.self)
    }
    
}
