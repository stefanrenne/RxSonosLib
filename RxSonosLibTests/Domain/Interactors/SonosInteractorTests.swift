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
    
    func testItCanProvideTheGroupsInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupsInteractor()) == GetGroupsInteractor.self)
    }
    
    func testItCanProvideTheNowPlayingInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideNowPlayingInteractor()) == GetNowPlayingInteractor.self)
    }
    
    func testItCanProvideTheTransportStateInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideTransportStateInteractor()) == GetTransportStateInteractor.self)
    }
    
    func testItCanProvideTheTrackImageInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideTrackImageInteractor()) == GetTrackImageInteractor.self)
    }
    
    func testItCanProvideTheGroupProgressInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupProgressInteractor()) == GetGroupProgressInteractor.self)
    }
    
    func testItCanProvideTheGroupQueueInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupQueueInteractor()) == GetGroupQueueInteractor.self)
    }
    
    func testItCanProvideTheGetVolumeInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGetVolumeInteractor()) == GetVolumeInteractor.self)
    }
    
    func testItCanProvideTheSetVolumeInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideSetVolumeInteractor()) == SetVolumeInteractor.self)
    }
    
}
