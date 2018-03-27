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
    
    func testItCanBeParsedFromString() {
        
       XCTAssertEqual(TransportState.map(string: "TRANSITIONING", for: MusicService.Spotify), TransportState.Transitioning)
       XCTAssertEqual(TransportState.map(string: "TRANSITIONING", for: MusicService.TuneIn), TransportState.Transitioning)
       XCTAssertEqual(TransportState.map(string: "TRANSITIONING", for: MusicService.TV), TransportState.Transitioning)
       XCTAssertEqual(TransportState.map(string: "TRANSITIONING", for: MusicService.Unknown), TransportState.Transitioning)
        
       XCTAssertEqual(TransportState.map(string: "PLAYING", for: MusicService.TuneIn), TransportState.PlayingStream)
       XCTAssertEqual(TransportState.map(string: "PLAYING", for: MusicService.TV), TransportState.PlayingStream)
        
       XCTAssertEqual(TransportState.map(string: "PLAYING", for: MusicService.Spotify), TransportState.PlayingQueue)
       XCTAssertEqual(TransportState.map(string: "PLAYING", for: MusicService.Unknown), TransportState.PlayingQueue)
        
       XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK", for: MusicService.Spotify), TransportState.PausedQueue)
       XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK", for: MusicService.TuneIn), TransportState.PausedQueue)
       XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK", for: MusicService.TV), TransportState.PausedQueue)
       XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK", for: MusicService.Unknown), TransportState.PausedQueue)
       XCTAssertEqual(TransportState.map(string: "PLAYING", for: MusicService.Unknown), TransportState.PlayingQueue)
        
       XCTAssertEqual(TransportState.map(string: "STOPPED", for: MusicService.Spotify), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "STOPPED", for: MusicService.TuneIn), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "STOPPED", for: MusicService.TV), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "STOPPED", for: MusicService.Unknown), TransportState.StoppedStream)
        
       XCTAssertEqual(TransportState.map(string: "randomstring", for: MusicService.Spotify), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "randomstring", for: MusicService.TuneIn), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "randomstring", for: MusicService.TV), TransportState.StoppedStream)
       XCTAssertEqual(TransportState.map(string: "randomstring", for: MusicService.Unknown), TransportState.StoppedStream)
    }
}
