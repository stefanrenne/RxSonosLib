//
//  TestHelpers.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

extension XCTestCase {
    
    /* Reset Repositories */
    func resetToFakeRepositories() {
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        let groupRepository = FakeGroupRepositoryImpl()
        RepositoryInjection.shared.groupRepository = groupRepository
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        RepositoryInjection.shared.musicProvidersRepository = FakeMusicProvidersRepositoryImpl()
        SonosInteractor.shared.allGroups.onNext(groupRepository.allGroups)
        SonosInteractor.shared.activeGroup.onNext(groupRepository.allGroups.first)
    }
    
    func resetToRealRepositories() {
        RepositoryInjection.shared.contentDirectoryRepository = ContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = GroupRepositoryImpl()
        RepositoryInjection.shared.renderingControlRepository = RenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = RoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = SSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = TransportRepositoryImpl()
        RepositoryInjection.shared.musicProvidersRepository = MusicProvidersRepositoryImpl()
    }
    
    /* Groups */
    func firstGroup() -> Group {
        return Group(master: firstRoom(), slaves: [])
    }
    
    func secondGroup() -> Group {
        return Group(master: firstRoom(), slaves: [secondRoom()])
    }
    
    func thirdGroup() -> Group {
        return Group(master: thirdRoom(), slaves: [])
    }
    
    /* Rooms */
    func firstRoom() -> Room {        
        return Room(ssdpDevice: firstDevice(), deviceDescription: firstDescription())
    }
    
    func secondRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.26:1400")!, usn: "uuid:RINCON_000002::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ANVIL)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000002", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: "RINCON_000001")
        
        let description = DeviceDescription(name: "Living", modalNumber: "Sub", modalName: "Sonos SUB", modalIcon: "/img/icon-Sub.png", serialNumber: "00-00-00-00-00-02:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
    
    func thirdRoom() -> Room {
        let device = SSDPDevice(ip: URL(string: "http://192.168.3.1:1400")!, usn: "uuid:RINCON_000008::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS5)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000008", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "93", proxy: nil)
        
        let description = DeviceDescription(name: "Kitchen", modalNumber: "S5", modalName: "Sonos PLAY:5", modalIcon: "/img/icon-S5.png", serialNumber: "00-00-00-00-00-08:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        
        return Room(ssdpDevice: device, deviceDescription: description)
    }
    
    /* Devices */
    func firstDevice() -> SSDPDevice {
        return SSDPDevice(ip: URL(string: "http://192.168.3.14:1400")!, usn: "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000001", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: nil)
    }
    
    /* Description */
    func firstDescription() -> DeviceDescription {
        return DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
    }
    
    /* Tracks */
    func firstTrack() -> MusicProviderTrack {
        return MusicProviderTrack(sid: 9, flags: nil, sn: nil, queueItem: 1, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")!, description: [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"])
    }
}
