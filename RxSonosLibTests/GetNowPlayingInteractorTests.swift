//
//  GetNowPlayingInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSwift
import RxBlocking

class GetNowPlayingInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
    
    func testItCanGetTheCurrentTrack() {
        let interactor = GetNowPlayingInteractor(transportRepository: transportRepository)
        let track = try! interactor.get(values: GetNowPlayingValues(group: firstGroup()))
            .toBlocking(
            ).first()!
        
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.queueItem, 7)
        XCTAssertEqual(track.time.value, 149)
        XCTAssertEqual(track.duration, 265)
        XCTAssertEqual(track.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.imageUri!.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.title, "Before I Die")
        XCTAssertEqual(track.artist, "Papa Roach")
        XCTAssertEqual(track.album, "The Connection")
    }
    
    func testItCantGetTheCurrentTrackWithAGroup() {
        let interactor = GetNowPlayingInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}

fileprivate extension GetNowPlayingInteractorTests {
    
    func firstGroup() -> Group {
        return Group(master: firstRoom(), slaves: [])
    }
    
    func firstRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
}
