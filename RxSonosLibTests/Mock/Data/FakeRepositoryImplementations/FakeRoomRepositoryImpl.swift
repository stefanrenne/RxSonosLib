//
//  FakeRoomRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSwift

class FakeRoomRepositoryImpl: RoomRepository {
    
    func getRoom(device: SSDPDevice) -> Observable<Room>? {
        let description = self.getDescription(for: device)
        let room = Room(ssdpDevice: device, deviceDescription: description)
        return Observable.just(room)
    }
    
}

fileprivate extension FakeRoomRepositoryImpl {
    
    func getDescription(for device: SSDPDevice) -> DeviceDescription {
        switch device.ip.absoluteString {
            
            /*
             Room: Living
             Type: 5.1
             Coordinator: Playbar
             */
            
            /* Type: Playbar */
        case "http://192.168.3.14:1400":
            return DeviceDescription(name: "Living", modalNumber: "S9", modalName: "Sonos PLAYBAR", modalIcon: "/img/icon-S9.png", serialNumber: "00-00-00-00-00-01:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            /* Type: SUB */
        case "http://192.168.3.26:1400":
            return DeviceDescription(name: "Living", modalNumber: "Sub", modalName: "Sonos SUB", modalIcon: "/img/icon-Sub.png", serialNumber: "00-00-00-00-00-02:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            /* Type: PLAY1 Left */
        case "http://192.168.3.20:1400":
            return DeviceDescription(name: "Living", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-03:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            /* Type: PLAY1 Right */
        case "http://192.168.3.21:1400":
            return DeviceDescription(name: "Living", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-04:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            
            /*
             Room: Bathroom
             Type: Mono
             Coordinator: PLAY:1
             */
            
            /* Type: PLAY:1 */
        case "http://192.168.3.3:1400":
            return DeviceDescription(name: "Bathroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-05:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            
            /*
             Room: Bedroom
             Type: Stereo
             Coordinator: PLAY:1
             */
            
            /* Type: PLAY:1 Left */
        case "http://192.168.3.6:1400":
            return DeviceDescription(name: "Bedroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-06:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            /* Type: PLAY:1 Right */
        case "http://192.168.3.7:1400":
            return DeviceDescription(name: "Bedroom", modalNumber: "S1", modalName: "Sonos PLAY:1", modalIcon: "/img/icon-S1.png", serialNumber: "00-00-00-00-00-07:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
            
            
            /*
             Room: Kitchen
             Type: Mono
             Coordinator: PLAY:5 (original)
             */
            
            /* Type: PLAY:5 (original) */
//        case "http://192.168.3.1:1400":
        default:
            return DeviceDescription(name: "Kitchen", modalNumber: "S5", modalName: "Sonos PLAY:5", modalIcon: "/img/icon-S5.png", serialNumber: "00-00-00-00-00-08:A", softwareVersion: "34.7-34220", hardwareVersion: "1.8.3.7-2")
        }
    }
}
