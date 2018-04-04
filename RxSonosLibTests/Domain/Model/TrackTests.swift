//
//  TrackTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class TrackTests: XCTestCase {
    
    func testItCanInitATrack() {
        let track = Track(service: .spotify, queueItem: 1, duration: 10, uri: "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif", title: "test")
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.duration, 10)
        XCTAssertEqual(track.queueItem, 1)
        XCTAssertEqual(track.uri, "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertEqual(track.title, "test")
        XCTAssertEqual(track.description(), [TrackDescription.title: "test"])
    }
    
    func testItCanCompareTracks() {
        XCTAssertEqual(firstSpotifyTrack(), firstSpotifyTrack())
    }
    
}

fileprivate extension TrackTests {
    func firstSpotifyTrack() -> Track {
        return SpotifyTrack(queueItem: 7, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")!, title: "Before I Die", artist: "Papa Roach", album: "The Connection")
    }
}
