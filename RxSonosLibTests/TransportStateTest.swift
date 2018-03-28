//
//  TransportStateTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class TransportStateTest: XCTestCase {
    
    func testItCanParsUnknownString() {
        XCTAssertEqual(TransportState.map(string: "randomstring"), TransportState.Stopped)
    }
    
    func testItCanParsePlayingString() {
        XCTAssertEqual(TransportState.map(string: "PLAYING"), TransportState.Playing)
    }
    
    func testItCanParsePausedString() {
        XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK"), TransportState.Paused)
    }
    
    func testItCanParseStoppedString() {
        XCTAssertEqual(TransportState.map(string: "STOPPED"), TransportState.Stopped)
    }
    
    func testItCanParseTransitioningString() {
        XCTAssertEqual(TransportState.map(string: "TRANSITIONING"), TransportState.Transitioning)
    }
}
