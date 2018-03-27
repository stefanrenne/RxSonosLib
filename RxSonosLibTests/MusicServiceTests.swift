//
//  MusicServiceTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class MusicServiceTests: XCTestCase {
    
    func testItCanParseUnkownMusicServices() {
        XCTAssertEqual(MusicService.map(string: nil), MusicService.Unknown)
        XCTAssertEqual(MusicService.map(string: ""), MusicService.Unknown)
        XCTAssertEqual(MusicService.map(string: "random"), MusicService.Unknown)
    }
    
    func testItCanParseSpotifyMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-sonos-spotify"), MusicService.Spotify)
    }
    
    func testItCanParseTuneInMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-rincon-mp3radio"), MusicService.TuneIn)
        XCTAssertEqual(MusicService.map(string: "aac"), MusicService.TuneIn)
    }
    
    func testItCanParseTVMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-sonos-htastream"), MusicService.TV)
    }
    
    func testItCanDetectStreamingServices() {
        XCTAssertEqual(MusicService.TuneIn.isStreamService, true)
        XCTAssertEqual(MusicService.TV.isStreamService, true)
        XCTAssertEqual(MusicService.Spotify.isStreamService, false)
        XCTAssertEqual(MusicService.Unknown.isStreamService, false)
    }
    
}
