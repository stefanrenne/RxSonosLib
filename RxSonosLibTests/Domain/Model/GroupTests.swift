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
    
    func testItCanGetTheGroupName() {
        let group = Group(master: firstRoom(), slaves: [thirthRoom(), secondRoom()])
        XCTAssertEqual(group.name, "Living +2")
    }
    
    func testItCanGetTheGroupNameWhenThereAreNoSlaved() {
        let group = Group(master: firstRoom(), slaves: [])
        XCTAssertEqual(group.name, "Living")
    }
    
    func testItCanGetTheActiveTrack() {
        let group = Group(master: firstRoom(), slaves: [])
        let track = try! group
            .getTrack()
            .toBlocking()
            .first()! as! SpotifyTrack
        
        XCTAssertEqual(track.service, .spotify)
        XCTAssertEqual(track.queueItem, 7)
        XCTAssertEqual(track.duration, 265)
        XCTAssertEqual(track.uri, "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.imageUri.absoluteString, "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")
        XCTAssertEqual(track.title, "Before I Die")
        XCTAssertEqual(track.artist, "Papa Roach")
        XCTAssertEqual(track.album, "The Connection")
        XCTAssertEqual(track.description(), [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
    }
    
    func testItCanGetTheTransportState() {
        let group = Group(master: firstRoom(), slaves: [])
        let result = try! group.getTransportState().toBlocking().first()!
        XCTAssertEqual(result.0, TransportState.paused)
        XCTAssertEqual(result.1, MusicService.spotify)
    }
    
    func testItCanSetTheTransportState() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Group(master: firstRoom(), slaves: [])
        let newState = try! group.set(transportState: .playing)
            .map({ return mock.activeState })
            .toBlocking()
            .first()!
        XCTAssertEqual(newState, TransportState.playing)
        
    }
    
    func testItCanGetTheVolume() {
        let group = Group(master: firstRoom(), slaves: [])
        let volume = try! group.getVolume().toBlocking().first()!
        XCTAssertEqual(volume, 70)
    }
    
    func testItCanSetTheVolume() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        let group = Group(master: firstRoom(), slaves: [])
        let newVolume = try! group.set(volume: 22)
            .map({ return mock.lastVolume })
            .toBlocking()
            .first()!
        XCTAssertEqual(newVolume, 22)
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
