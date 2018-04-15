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
        XCTAssertEqual(TransportState.map(string: "randomstring"), TransportState.stopped)
    }
    
    func testItCanParsePlayingString() {
        XCTAssertEqual(TransportState.map(string: "PLAYING"), TransportState.playing)
    }
    
    func testItCanParsePausedString() {
        XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK"), TransportState.paused)
    }
    
    func testItCanParseStoppedString() {
        XCTAssertEqual(TransportState.map(string: "STOPPED"), TransportState.stopped)
    }
    
    func testItCanParseTransitioningString() {
        XCTAssertEqual(TransportState.map(string: "TRANSITIONING"), TransportState.transitioning)
    }
    
    func testItCanCreateActionStateForPlaying() {
        XCTAssertEqual(TransportState.playing.actionState(for: MusicService.spotify), TransportState.paused)
        XCTAssertEqual(TransportState.playing.actionState(for: MusicService.unknown), TransportState.paused)
        XCTAssertEqual(TransportState.playing.actionState(for: MusicService.tunein), TransportState.stopped)
        XCTAssertEqual(TransportState.playing.actionState(for: MusicService.tv), TransportState.stopped)
    }
    
    func testItCanCreateActionStateForPause() {
        XCTAssertEqual(TransportState.paused.actionState(for: MusicService.spotify), TransportState.playing)
        XCTAssertEqual(TransportState.paused.actionState(for: MusicService.tunein), TransportState.playing)
        XCTAssertEqual(TransportState.paused.actionState(for: MusicService.tv), TransportState.playing)
        XCTAssertEqual(TransportState.paused.actionState(for: MusicService.unknown), TransportState.playing)
    }
    
    func testItCanCreateActionStateForStopped() {
        XCTAssertEqual(TransportState.stopped.actionState(for: MusicService.spotify), TransportState.playing)
        XCTAssertEqual(TransportState.stopped.actionState(for: MusicService.tunein), TransportState.playing)
        XCTAssertEqual(TransportState.stopped.actionState(for: MusicService.tv), TransportState.playing)
        XCTAssertEqual(TransportState.stopped.actionState(for: MusicService.unknown), TransportState.playing)
    }
    
    func testItCanCreateActionStateForTransitioning() {
        XCTAssertEqual(TransportState.transitioning.actionState(for: MusicService.spotify), TransportState.transitioning)
        XCTAssertEqual(TransportState.transitioning.actionState(for: MusicService.tunein), TransportState.transitioning)
        XCTAssertEqual(TransportState.transitioning.actionState(for: MusicService.tv), TransportState.transitioning)
        XCTAssertEqual(TransportState.transitioning.actionState(for: MusicService.unknown), TransportState.transitioning)
    }
}
