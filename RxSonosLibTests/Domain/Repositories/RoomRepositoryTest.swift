//
//  RoomRepositoryTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxSSDP
import Mockingjay
@testable import RxSonosLib

class RoomRepositoryTest: XCTestCase {
    
    private let roomRepository: RoomRepository = RoomRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.clear(removeLongCache: true)
    }
    
    func testItCanCreateARoom() {
        
        var description = "<device>"
            description += "<deviceType>urn:schemas-upnp-org:device:ZonePlayer:1</deviceType>"
            description += "<friendlyName>192.168.3.14 - Sonos PLAYBAR</friendlyName>"
            description += "<manufacturer>Sonos, Inc.</manufacturer>"
            description += "<modelNumber>S9</modelNumber>"
            description += "<modelDescription>Sonos PLAYBAR</modelDescription>"
            description += "<modelName>Sonos PLAYBAR</modelName>"
            description += "<softwareVersion>34.7-34220</softwareVersion>"
            description += "<hardwareVersion>1.9.1.10-2</hardwareVersion>"
            description += "<serialNum>00-00-00-00-00-01:A</serialNum>"
            description += "<UDN>uuid:RINCON_000001</UDN>"
            description += "<iconList>"
                description += "<icon>"
                    description += "<id>0</id>"
                    description += "<mimetype>image/png</mimetype>"
                    description += "<width>48</width>"
                    description += "<height>48</height>"
                    description += "<depth>24</depth>"
                    description += "<url>/img/icon-S9.png</url>"
                description += "</icon>"
            description += "</iconList>"
            description += "<displayVersion>7.0</displayVersion>"
            description += "<roomName>Living</roomName>"
            description += "<displayName>PLAYBAR</displayName>"
        description += "</device>"
        
        stub(uri("/xml/device_description.xml"), xml(description))
        
        do {
        let room = try roomRepository
            .getRoom(device: firstDevice())!
            .toBlocking()
            .single()
        
            XCTAssertEqual(room.uuid, "RINCON_000001")
            XCTAssertEqual(room.hasProxy, false)
            XCTAssertEqual(room.ip.absoluteString, "http://192.168.3.14:1400")
            XCTAssertEqual(room.name, "Living")
            XCTAssertEqual(room.userAgent, "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)")
        
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItCanOnlyCreateARoomForASonosDevice() throws {
        stub(everything, http(404))
        
        let hueDevice = try SSDPDevice.map(SSDPResponse(data: ["USN": "uuid:2f402f80-da50-11e1-9b23-00178809d9bf::upnp:rootdevice", "SERVER": "FreeRTOS/7.4.2 UPnP/1.0 IpBridge/1.15.0", "EXT": "", "ST": "upnp:rootdevice", "LOCATION": "http://10.0.1.2:80/description.xml", "CACHE-CONTROL": "max-age=100", "HOST": "239.255.255.250:1900", "hue-bridgeid": "00100800FF000900"]))!

        let room = roomRepository.getRoom(device: hueDevice)
        XCTAssertNil(room)
    }
    
    func testItCantMapInvalidXMLDescriptionFiles() {
        
        stub(uri("/xml/device_description.xml"), xml("<device>"))
        
        XCTAssertThrowsError(try roomRepository.getRoom(device: firstDevice())!.toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.noData.localizedDescription)
        }
    }
    
    func testItCantMapIncorrectXMLDescriptionFiles() {
        
        stub(uri("/xml/device_description.xml"), xml("<device></device>"))
        
        XCTAssertThrowsError(try roomRepository.getRoom(device: firstDevice())!.toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.noData.localizedDescription)
        }
    }
    
    func testItCanCompareRooms() throws {
        let roomRepository: RoomRepository = FakeRoomRepositoryImpl()
        let room1 = try roomRepository.getRoom(device: firstDevice())!.toBlocking().single()
        
        let room1duplicate = try roomRepository.getRoom(device: firstDevice())!.toBlocking().single()
        
        let room2 = try roomRepository.getRoom(device: SSDPDevice(ip: URL(string: "http://192.168.3.26:1400")!, usn: "uuid:RINCON_000002::urn:schemas-upnp-org:device:ZonePlayer:1", server: "Linux UPnP/1.0 Sonos/34.7-34220 (ZPS9)", ext: "", st: "urn:schemas-upnp-org:device:ZonePlayer:1", location: "/xml/device_description.xml", cacheControl: "max-age = 1800", uuid: "RINCON_000002", wifiMode: "0", variant: "0", household: "SONOS_HOUSEHOLD_1", bootseq: "81", proxy: "RINCON_000001"))!.toBlocking().single()
        
        XCTAssertEqual(room1, room1duplicate)
        XCTAssertNotEqual(room1, room2)
    }
    
}
