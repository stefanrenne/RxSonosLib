//
//  SSDPRepositoryTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxSSDP
import RxBlocking
@testable import RxSonosLib

class SSDPRepositoryTest: XCTestCase {
    
    override func setUp() {
        CacheManager.shared.deleteAll()
    }
    
    func testItCanSearchForAnDevice() throws {
        
        let ssdpRepository: SSDPRepository = FakeSSDPRepositoryImpl()
        
        let response = try ssdpRepository.scan(searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1")
            .toBlocking()
            .single()
        
        XCTAssertEqual(response.first!.data, ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"])
    }
    
    func testItCanMapSSDPResponsesToDevices() {
        let emptyResponse = SSDPResponse(data: [:])
        let sonosResponse = SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"])
        
        XCTAssertNil(SSDPDevice.map(emptyResponse))
        XCTAssertNotNil(SSDPDevice.map(sonosResponse))
    }
    
    func testItCanCompareSimilarSSDPDevices() {
        
        let livingRoomResponse = SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"])
        let livingRoomDevice1 = SSDPDevice.map(livingRoomResponse)
        let livingRoomDevice2 = SSDPDevice.map(livingRoomResponse)
        
        XCTAssertEqual(livingRoomDevice1, livingRoomDevice2)
    }
    
    func testItCantCompareDifferentSSDPDevices() {
        
        let livingRoomDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"]))
        
        let bathroomDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000005::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.3:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "46"]))
        
        XCTAssertNotEqual(livingRoomDevice, bathroomDevice)
    }
    
    func testItCantDetectSonosDevices() {
        let livingRoomDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"]))
        
        let hueDevice = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:2f402f80-da50-11e1-9b23-00178809d9bf::upnp:rootdevice", "SERVER": "FreeRTOS/7.4.2 UPnP/1.0 IpBridge/1.15.0", "EXT": "", "ST": "upnp:rootdevice", "LOCATION": "http://10.0.1.2:80/description.xml", "CACHE-CONTROL": "max-age=100", "HOST": "239.255.255.250:1900", "hue-bridgeid": "001788FFFE09D9BF"]))
        
        XCTAssertTrue(livingRoomDevice!.isSonosDevice)
        XCTAssertFalse(hueDevice!.isSonosDevice)
    }
    
    func testItCanDetectProxys() {
        let deviceWithoutProxy = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"]))
        
        let deviceWithProxy = SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:RINCON_000002::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ANVIL)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.26:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "92", "X-RINCON-PROXY": "RINCON_000001"]))
        
        XCTAssertTrue(deviceWithProxy!.hasProxy)
        XCTAssertFalse(deviceWithoutProxy!.hasProxy)
        
    }
    
}
