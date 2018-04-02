//
//  GroupTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

class GroupTests: XCTestCase {
    
    func testItCanCompareGroupsOnMaster() {
        let group1 = Group(master: firstRoom(), slaves: [])
        let group2 = Group(master: firstRoom(), slaves: [])
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMaster() {
        let group1 = Group(master: firstRoom(), slaves: [])
        let group2 = Group(master: secondRoom(), slaves: [])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareGroupsWithDifferentOrderSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [secondRoom(), thirthRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirthRoom(), secondRoom()])
        
        XCTAssertEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [secondRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirthRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanCompareDifferentGroupsOnMultipleSlaves() {
        let group1 = Group(master: firstRoom(), slaves: [thirthRoom(), secondRoom()])
        let group2 = Group(master: firstRoom(), slaves: [thirthRoom()])
        
        XCTAssertNotEqual(group1, group2)
    }
    
    func testItCanSetTheGroupName() {
        let group = Group(master: firstRoom(), slaves: [thirthRoom(), secondRoom()])
        let nameObservable = group.name.asObservable()
        XCTAssertEqual(try! nameObservable.toBlocking().first(), "Living +2")
    }
    
    func testItCanChangeTheGroupNames() {
        let group = Group(master: firstRoom(), slaves: [])
        let nameObservable = group.name.asObservable()
        XCTAssertEqual(try! nameObservable.toBlocking().first(), "Living")
        
        group.slaves = [thirthRoom(), secondRoom()]
        XCTAssertEqual(try! nameObservable.toBlocking().first(), "Living +2")
    }
    
}

fileprivate extension GroupTests {
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
    
    func thirthRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.1:1400")!, usn: "uuid:RINCON_000008::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS5)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000008", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "93", proxy: nil)
        
        let description = DeviceDescription(name: "Kitchen", modalNumber: "S5", modalName: "Sonos PLAY:5", modalIcon: "/img/icon-S5.png", serialNumber: "00-00-00-00-00-08:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
}
