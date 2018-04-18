//
//  SetNextInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class SetNextInteractorTests: XCTestCase {
    
    let transportRepository: FakeTransportRepositoryImpl = FakeTransportRepositoryImpl()
    
    func testItCanSetTheNextTrack() {
        XCTAssertEqual(transportRepository.nextTrackCounter, 0)
        XCTAssertEqual(transportRepository.previousTrackCounter, 0)
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertNoThrow(try interactor
            .get(values: SetNextTrackValues(group: firstGroup()))
            .toBlocking()
            .toArray())
        XCTAssertEqual(transportRepository.nextTrackCounter, 1)
        XCTAssertEqual(transportRepository.previousTrackCounter, 0)
    }
    
    func testItCantSetTheNextTrackWithoutVolumeValues() {
        let interactor = SetNextTrackInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}

fileprivate extension SetNextInteractorTests {
    func firstGroup() -> Group {
        return Group(master: firstRoom(), slaves: [])
    }
    
    func firstRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
}
