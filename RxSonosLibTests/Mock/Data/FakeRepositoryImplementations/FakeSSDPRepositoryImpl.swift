//
//  FakeSSDPRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSwift
import RxSSDP

class FakeSSDPRepositoryImpl: SSDPRepository {
    
    func scan(searchTarget: String) -> Observable<[SSDPResponse]> {
        return Observable.just(FakeSSDPRepositoryImpl.dummyDevices())
    }
    
}

extension FakeSSDPRepositoryImpl {
    
    static func dummyDevices() -> [SSDPResponse] {
        
        var devices = [SSDPResponse]()
        
        
        /*
         Room: Living Room
         Type: 5.1
         Coordinator: Playbar
         */
        
        /* Type: Playbar */
        let livingRoomCoordinator = SSDPResponse(data: ["USN": "uuid:RINCON_000001::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.14:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "81"])
        devices.append(livingRoomCoordinator)
        
        /* Type: SUB */
        let livingRoomSatelliteSub = SSDPResponse(data: ["USN": "uuid:RINCON_000002::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ANVIL)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.26:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "92", "X-RINCON-PROXY": "RINCON_000001"])
        devices.append(livingRoomSatelliteSub)
        
        /* Type: PLAY1 Left */
        let livingRoomSatelliteLeft = SSDPResponse(data: ["USN": "uuid:RINCON_000003::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.20:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "11", "X-RINCON-PROXY": "RINCON_000001"])
        devices.append(livingRoomSatelliteLeft)
        
        /* Type: PLAY1 Right */
        let livingRoomSatelliteRight = SSDPResponse(data: ["USN": "uuid:RINCON_000004::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.21:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "2", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "12", "X-RINCON-PROXY": "RINCON_000001"])
        devices.append(livingRoomSatelliteRight)
        
        /*
         Room: Bathroom
         Type: Mono
         Coordinator: PLAY:1
         */
        
        /* Type: PLAY:1 */
        let bathroom = SSDPResponse(data: ["USN": "uuid:RINCON_000005::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.3:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "46"])
        devices.append(bathroom)
        
        
        /*
         Room: Bedroom
         Type: Stereo
         Coordinator: PLAY:1
         */
        
        /* Type: PLAY:1 Left */
        let bedroomLeft = SSDPResponse(data: ["USN": "uuid:RINCON_000006::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.6:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "66"])
        devices.append(bedroomLeft)
        
        /* Type: PLAY:1 Right */
        let bedroomRight = SSDPResponse(data: ["USN": "uuid:RINCON_000007::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS1)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.7:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "51"])
        devices.append(bedroomRight)
        
        /*
         Room: Kitchen
         Type: Mono
         Coordinator: PLAY:5 (original)
         */
        
        /* Type: PLAY:5 (original) */
        let kitchen = SSDPResponse(data: ["USN": "uuid:RINCON_000008::urn:schemas-upnp-org:device:ZonePlayer:1", "SERVER": "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS5)", "EXT": "", "ST": "urn:schemas-upnp-org:device:ZonePlayer:1", "LOCATION": "http://192.168.3.1:1400/xml/device_description.xml", "CACHE-CONTROL": "max-age = 1800", "X-RINCON-WIFIMODE": "0", "X-RINCON-VARIANT": "0", "X-RINCON-HOUSEHOLD": "SONOS_HOUSEHOLD_1", "X-RINCON-BOOTSEQ": "93"])
        devices.append(kitchen)
        
        return devices
    }
}
