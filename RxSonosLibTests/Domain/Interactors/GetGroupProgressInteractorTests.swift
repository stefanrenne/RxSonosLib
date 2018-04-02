//
//  GetGroupProgressInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RxSonosLib

class GetGroupProgressInteractorTests: XCTestCase {
    
    let transportRepository: TransportRepository = FakeTransportRepositoryImpl()
    
    func testItCanGetTheCurrentProgress() {
        let interactor = GetGroupProgressInteractor(transportRepository: transportRepository)
        let progress = try! interactor.get(values: GetGroupProgressValues(group: firstGroup()))
            .toBlocking(
            ).first()!
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.timeString, "0:30")
        XCTAssertEqual(progress.duration, 60)
        XCTAssertEqual(progress.durationString, "1:00")
        XCTAssertEqual(progress.progress, 0.5)
        XCTAssertEqual(progress.remainingTimeString, "-0:30")
    }
    
    func testItCantGetTheCurrentProgressWithoutAGroup() {
        let interactor = GetGroupProgressInteractor(transportRepository: transportRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, NSError.sonosLibInvalidImplementationError().localizedDescription)
        }
    }
    
}

extension GetGroupProgressInteractorTests {
    
    func firstGroup() -> Group {
        return Group(master: firstRoom(), slaves: [])
    }
    
    func firstRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
}
