//
//  RenderingControlRepositoryTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Mockingjay
@testable import RxSonosLib

class RenderingControlRepositoryTests: XCTestCase {
    
    let renderingControlRepository: RenderingControlRepository = RenderingControlRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.deleteAll()
    }
    
    func testItCanGetTheVolume() {
        
        stub(soap(call: .getVolume), soapXml("<CurrentVolume>44</CurrentVolume>"))
        
        let volume = try! renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 44)
    }
    
    func testItCanGetADefaultVolume() {
        
        stub(soap(call: .getVolume), soapXml(""))
        
        let volume = try! renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 0)
    }
    
    func testItCanGetTheAverageGroupVolume() {
        
        stub(soap(room: firstRoom(), call: .getVolume), soapXml("<CurrentVolume>60</CurrentVolume>"))
        stub(soap(room: secondRoom(), call: .getVolume), soapXml("<CurrentVolume>20</CurrentVolume>"))
        
        let volume = try! renderingControlRepository
            .getVolume(for: firstGroup())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 40)
    }
    
}

extension RenderingControlRepositoryTests {
    
    func firstGroup() -> Group {
        return Group(master: firstRoom(), slaves: [secondRoom()])
    }
    
    func firstRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
        
        let description = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
    
    func secondRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.26:1400")!, usn: "uuid:RINCON_000002::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ANVIL)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000002", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: "RINCON_000001")
        
        let description = DeviceDescription(name: "Living", modalNumber: "Sub", modalName: "Sonos SUB", modalIcon: "/img/icon-Sub.png", serialNumber: "00-00-00-00-00-02:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
}
