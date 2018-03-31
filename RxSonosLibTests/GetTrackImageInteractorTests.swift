//
//  GetTrackImageInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetTrackImageInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
    
    func testItCanGetTheCurrentImage() {
        let interactor = GetTrackImageInteractor(transportRepository: transportRepository)
        let image = try! interactor.get(values: GetTrackImageValues(track: firstTrack()))
            .toBlocking(
            ).first()!
        
        XCTAssertEqual(image, UIImage(named: "papa-roach-the-connection.jpg"))
    }
    
    func testItCantGetTheCurrentImageWithoutATrack() {
        let interactor = GetTrackImageInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}

extension GetTrackImageInteractorTests {
    func firstTrack() -> Track {
        return Track(service: .spotify, queueItem: 7, time: 149, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1"), title: "Before I Die", artist: "Papa Roach", album: "The Connection")
    }
}
