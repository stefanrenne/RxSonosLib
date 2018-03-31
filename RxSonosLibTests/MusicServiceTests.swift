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
        XCTAssertEqual(MusicService.map(string: nil), MusicService.unknown)
        XCTAssertEqual(MusicService.map(string: ""), MusicService.unknown)
        XCTAssertEqual(MusicService.map(string: "random"), MusicService.unknown)
    }
    
    func testItCanParseSpotifyMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-sonos-spotify"), MusicService.spotify)
    }
    
    func testItCanParseTuneInMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-rincon-mp3radio"), MusicService.tunein)
        XCTAssertEqual(MusicService.map(string: "aac"), MusicService.tunein)
    }
    
    func testItCanParseTVMusicServices() {
        XCTAssertEqual(MusicService.map(string: "x-sonos-htastream"), MusicService.tv)
    }
    
}
