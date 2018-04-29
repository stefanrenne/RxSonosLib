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
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = FakeGroupRepositoryImpl()
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        _ = SonosInteractor.shared
        super.setUp()
    }
    
    override func tearDown() {
        RepositoryInjection.shared.contentDirectoryRepository = ContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = GroupRepositoryImpl()
        RepositoryInjection.shared.renderingControlRepository = RenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = RoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = SSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = TransportRepositoryImpl()
        super.tearDown()
    }
    
    func testItCanInitATrack() {
        let track = Track(service: .spotify, queueItem: 1, duration: 10, uri: "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif", title: "test")
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.duration, 10)
        XCTAssertEqual(track.queueItem, 1)
        XCTAssertEqual(track.uri, "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif")
        XCTAssertEqual(track.title, "test")
        XCTAssertEqual(track.description(), [TrackDescription.title: "test"])
    }
    
    func testItCanSortTrackDescriptions() {
        let descriptions = [TrackDescription.artist, TrackDescription.information, TrackDescription.album, TrackDescription.title]
        let sortedDescriptions = descriptions.sorted(by: { $0 < $1 })
        XCTAssertEqual(sortedDescriptions, [TrackDescription.title, TrackDescription.information, TrackDescription.artist, TrackDescription.album])
    }
    
    func testItCanFilterTheDescription() {
        let track = firstSpotifyTrack()
        
        XCTAssertEqual(track.description(filterd: [TrackDescription.information]), ["Before I Die", "Papa Roach", "The Connection"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title]), ["Papa Roach", "The Connection"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title, TrackDescription.album]), ["Papa Roach"])
        XCTAssertEqual(track.description(filterd: [TrackDescription.title, TrackDescription.album, TrackDescription.artist]), [])
    }
    
    func testItCanGetJustOneDescriptionField() {
        let track = firstSpotifyTrack()
        
        XCTAssertEqual(track.description()[TrackDescription.title], "Before I Die")
        XCTAssertEqual(track.description()[TrackDescription.album], "The Connection")
        XCTAssertEqual(track.description()[TrackDescription.artist], "Papa Roach")
        XCTAssertNil(track.description()[TrackDescription.information])
    }
    
    func testItCanCompareTracks() {
        XCTAssertEqual(firstSpotifyTrack(), firstSpotifyTrack())
    }
    
    func testItCanGetTheTrackImage() {
        let imageData = try! Observable
            .just(firstSpotifyTrack())
            .getImage()
            .toBlocking()
            .first()!
        
        let expectedData = UIImagePNGRepresentation(UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        XCTAssertEqual(imageData, expectedData)
    }
    
}

fileprivate extension TrackTests {
    func firstSpotifyTrack() -> Track {
        return SpotifyTrack(queueItem: 7, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")!, title: "Before I Die", artist: "Papa Roach", album: "The Connection")
    }
}
