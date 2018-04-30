//
//  MusicServiceTypeTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class MusicServiceTypeTests: XCTestCase {
    
    func testItCanParseUnkownMusicServiceTypes() {
        XCTAssertEqual(MusicServiceType.map(string: nil), MusicServiceType.unknown)
        XCTAssertEqual(MusicServiceType.map(string: ""), MusicServiceType.unknown)
        XCTAssertEqual(MusicServiceType.map(string: "random"), MusicServiceType.unknown)
    }
    
    func testItCanParseSpotifyMusicServiceTypes() {
        XCTAssertEqual(MusicServiceType.map(string: "x-sonos-spotify"), MusicServiceType.spotify)
    }
    
    func testItCanParseTuneInMusicServiceTypes() {
        XCTAssertEqual(MusicServiceType.map(string: "x-rincon-mp3radio"), MusicServiceType.tunein)
        XCTAssertEqual(MusicServiceType.map(string: "aac"), MusicServiceType.tunein)
    }
    
    func testItCanParseTVMusicServiceTypes() {
        XCTAssertEqual(MusicServiceType.map(string: "x-sonos-htastream"), MusicServiceType.tv)
    }
    
    func testItCanDetectAStreamService() {
        XCTAssertTrue(MusicServiceType.tv.isStreamingService)
        XCTAssertTrue(MusicServiceType.tunein.isStreamingService)
        XCTAssertFalse(MusicServiceType.unknown.isStreamingService)
        XCTAssertFalse(MusicServiceType.spotify.isStreamingService)
    }
    
}
