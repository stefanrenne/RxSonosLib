//
//  TrackTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
import RxSwift
@testable import RxSonosLib

class TrackTests: XCTestCase {
    
    override func setUp() {
        resetToFakeRepositories()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        resetToRealRepositories()
    }
    
    func testItCanInitATrack() {
        let track = TVTrack(queueItem: 1, uri: "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertEqual(track.duration, 0)
        XCTAssertEqual(track.queueItem, 1)
        XCTAssertEqual(track.uri, "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertNil(track.title)
        XCTAssertNil(track.album)
        XCTAssertNil(track.artist)
        XCTAssertNil(track.information)
        XCTAssertEqual(track.description, [:])
    }
    
    func testItCanSortTrackDescriptions() {
        let descriptions = [TrackDescription.artist, TrackDescription.information, TrackDescription.album, TrackDescription.title]
        let sortedDescriptions = descriptions.sorted(by: { $0 < $1 })
        XCTAssertEqual(sortedDescriptions, [TrackDescription.title, TrackDescription.information, TrackDescription.artist, TrackDescription.album])
    }
    
    func testItCanFilterTheDescription() {
        let track = firstTrack()
        
        XCTAssertEqual(track.description(filterd: [TrackDescription.information]), ["Before I Die", "Papa Roach", "The Connection"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title]), ["Papa Roach", "The Connection"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title, TrackDescription.album]), ["Papa Roach"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title, TrackDescription.album, TrackDescription.artist]), [])
    }
    
    func testItCanGetJustOneDescriptionField() {
        let track = firstTrack()
        
        XCTAssertEqual(track.description[TrackDescription.title], "Before I Die")
        XCTAssertEqual(track.description[TrackDescription.album], "The Connection")
        XCTAssertEqual(track.description[TrackDescription.artist], "Papa Roach")
        XCTAssertNil(track.description[TrackDescription.information])
    }
    
    func testItCanCompareTracks() {
        XCTAssertEqual(firstTrack(), firstTrack())
    }
    
    func testItCanGetTheTrackImage() throws {
        let imageData = try Observable
            .just(firstTrack())
            .getImage()
            .toBlocking()
            .first()!
        
        let expectedData = UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!.pngData()
        XCTAssertEqual(imageData, expectedData)
    }
    
}
