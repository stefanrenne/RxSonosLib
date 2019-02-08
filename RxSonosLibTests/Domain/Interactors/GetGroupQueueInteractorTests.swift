//
//  GetGroupQueueInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetGroupQueueInteractorTests: XCTestCase {
    
    let contentDirectoryRepository: ContentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
    
    func testItCanGetTheCurrentQueue() throws {
        let interactor = GetGroupQueueInteractor(contentDirectoryRepository: contentDirectoryRepository)
        interactor.requestValues = GetGroupQueueValues(group: firstGroup())
        
        let queue = try interactor
            .get()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(queue.count, 2)
        
        let track1 = queue[0]
        XCTAssertEqual(track1.providerId, 9)
        XCTAssertNil(track1.flags)
        XCTAssertNil(track1.sn)
        XCTAssertEqual(track1.queueItem, 1)
        XCTAssertEqual(track1.duration, 265)
        XCTAssertEqual(track1.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track1.title, "Before I Die")
        XCTAssertEqual(track1.artist, "Papa Roach")
        XCTAssertEqual(track1.album, "The Connection")
        XCTAssertNil(track1.information)
        XCTAssertEqual(track1.description, [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
        
        let track2 = queue[1]
        XCTAssertEqual(track2.providerId, 9)
        XCTAssertNil(track2.flags)
        XCTAssertNil(track2.sn)
        XCTAssertEqual(track2.queueItem, 2)
        XCTAssertEqual(track2.duration, 197)
        XCTAssertEqual(track2.uri, "x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2cTvamkNzLsIWrSHHW8yzy?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track2.title, "Christ Copyright")
        XCTAssertEqual(track2.artist, "Nothing More")
        XCTAssertEqual(track2.album, "Nothing More")
        XCTAssertNil(track2.information)
        XCTAssertEqual(track2.description, [TrackDescription.title: "Christ Copyright", TrackDescription.artist: "Nothing More", TrackDescription.album: "Nothing More"])
    }
    
    func testItCantGetTheCurrentQueueWithoutAGroup() {
        let interactor = GetGroupQueueInteractor(contentDirectoryRepository: contentDirectoryRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
    }
    
}
