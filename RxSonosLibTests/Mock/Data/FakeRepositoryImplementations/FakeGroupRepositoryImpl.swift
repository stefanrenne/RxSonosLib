//
//  FakeGroupRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSSDP
import RxSwift

class FakeGroupRepositoryImpl: GroupRepository {
    
    private let returnNoGroups: Bool
    init(returnNoGroups: Bool = false) {
        self.returnNoGroups = returnNoGroups
    }
    
    func getGroups(for rooms: [Room]) -> Observable<[Group]> {
        if returnNoGroups {
            return Observable<[Group]>.just([])
        } else {
            return Observable<[Group]>.just(allGroups)
        }
    }
    
    lazy var allGroups: [Group] = {
        
        var groups = [Group]()
        
        /*
         Room: Living Room
         Type: 5.1
         Coordinator: Playbar
         */
        
        /* Type: Playbar */
        let livingDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"]))!
        let livingDescription = DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        let livingRoom = Room(ssdpDevice: livingDevice, deviceDescription: livingDescription)
        groups.append(Group(master: livingRoom, slaves: []))
        
        /*
         Room: Bathroom
         Type: Mono
         Coordinator: PLAY:1
         */
        
        /* Type: PLAY:1 */
        let bathroomDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000005::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.3:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "46"]))!
        let bathroomDescription = DeviceDescription(name: "Bathroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-05:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        let bathroomRoom = Room(ssdpDevice: bathroomDevice, deviceDescription: bathroomDescription)
        groups.append(Group(master: bathroomRoom, slaves: []))
        
        
        /*
         Room: Bedroom
         Type: Stereo
         Coordinator: PLAY:1
         */
        
        /* Type: PLAY:1 Left */
        let bedroomDeviceLeft = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000006::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.6:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "66"]))!
        let bedroomDescriptionLeft = DeviceDescription(name: "Bedroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-06:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        let bedRoomLeft = Room(ssdpDevice: bedroomDeviceLeft, deviceDescription: bedroomDescriptionLeft)
        groups.append(Group(master: bedRoomLeft, slaves: []))
        
        /* Type: PLAY:1 Right */
        let bedroomDeviceRight = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000007::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.7:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "51"]))!
        let bedroomDescriptionRight = DeviceDescription(name: "Bedroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-07:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        let bedRoomRight = Room(ssdpDevice: bedroomDeviceRight, deviceDescription: bedroomDescriptionRight)
        groups.append(Group(master: bedRoomRight, slaves: []))
        
        /*
         Room: Kitchen
         Type: Mono
         Coordinator: PLAY:5 (original)
         */
        
        /* Type: PLAY:5 (original) */
        let kitchenDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000008::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS5)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.1:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "93"]))!
        let kitchenDescription = DeviceDescription(name: "Kitchen", modalNumber: "S5", modalName: "Sonos PLAY:5", modalIcon: "/img/icon-S5.png", serialNumber: "00-00-00-00-00-08:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        let kitchenRoom = Room(ssdpDevice: kitchenDevice, deviceDescription: kitchenDescription)
        groups.append(Group(master: kitchenRoom, slaves: []))
        
        return groups
    }()
    
}
