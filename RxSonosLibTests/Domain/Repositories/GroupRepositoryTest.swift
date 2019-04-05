//
//  GroupRepositoryTest.swift
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

class GroupRepositoryTest: XCTestCase {
    
    let ssdpRepository: SSDPRepository = FakeSSDPRepositoryImpl()
    let roomRepository: RoomRepository = FakeRoomRepositoryImpl()
    let groupRepository: GroupRepository = GroupRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.clear(removeLongCache: true)
    }
    
    func testItCanGetGroups() throws {
        
        var response = "<ZoneGroupState>"
            response += "<ZoneGroupState>".encodeString()
                response += "<ZoneGroups>".encodeString()
                    response += "<ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:314\">".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000006\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000007\" Invisible=\"1\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000005\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000001\">".encodeString()
                            response += "<Satellite UUID=\"RINCON_000002\" Invisible=\"1\"/>".encodeString()
                            response += "<Satellite UUID=\"RINCON_000003\" Invisible=\"1\"/>".encodeString()
                            response += "<Satellite UUID=\"RINCON_000004\"/>".encodeString()
                        response += "</ZoneGroupMember>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000008\"/>".encodeString()
                    response += "</ZoneGroup>".encodeString()
                response += "</ZoneGroups>".encodeString()
                response += "<VanishedDevices></VanishedDevices>".encodeString()
            response += "</ZoneGroupState>".encodeString()
        response += "</ZoneGroupState>"
        stub(soap(call: GroupTarget.state), soapXml(response))
        
        let groups = try groupRepository
            .getGroups(for: getRooms())
            .toBlocking()
            .single()
        
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0].master.uuid, "RINCON_000001")
        XCTAssertEqual(groups[0].slaves.count, 4)
        XCTAssertEqual(groups[0].slaves[0].uuid, "RINCON_000006")
        XCTAssertEqual(groups[0].slaves[1].uuid, "RINCON_000005")
        XCTAssertEqual(groups[0].slaves[2].uuid, "RINCON_000004")
        XCTAssertEqual(groups[0].slaves[3].uuid, "RINCON_000008")
    }
    
    func testItCanNotPerformTheRequestWhenThereAreNoRooms() throws {
        
        var response = "<ZoneGroupState>"
            response += "<ZoneGroupState>".encodeString()
                response += "<ZoneGroups>".encodeString()
                    response += "<ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:314\">".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000006\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000007\" Invisible=\"1\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000005\"/>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000001\">".encodeString()
                            response += "<Satellite UUID=\"RINCON_000002\" Invisible=\"1\"/>".encodeString()
                            response += "<Satellite UUID=\"RINCON_000003\" Invisible=\"1\"/>".encodeString()
                            response += "<Satellite UUID=\"RINCON_000004\" Invisible=\"1\"/>".encodeString()
                        response += "</ZoneGroupMember>".encodeString()
                        response += "<ZoneGroupMember UUID=\"RINCON_000008\"/>".encodeString()
                    response += "</ZoneGroup>".encodeString()
                response += "</ZoneGroups>".encodeString()
                response += "<VanishedDevices></VanishedDevices>".encodeString()
            response += "</ZoneGroupState>".encodeString()
        response += "</ZoneGroupState>"
        stub(soap(call: GroupTarget.state), soapXml(response))
        
        let groups = try groupRepository
            .getGroups(for: [])
            .toBlocking()
            .single()
        
        XCTAssertEqual(groups, [])
    }
    
    func testItCanGetGroupsSonosV49Response() throws {
        
        let response = "<ZoneGroupState>" + "<ZoneGroupState><ZoneGroups><ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:2009121375\"><ZoneGroupMember UUID=\"RINCON_000001\" Location=\"http://10.10.126.66:1400/xml/device_description.xml\" ZoneName=\"Room 1\" Icon=\"x-rincon-roomicon:living\" Configuration=\"1\" SoftwareVersion=\"49.2-63270\" MinCompatibleVersion=\"48.0-00000\" LegacyCompatibleVersion=\"36.0-00000\" ChannelMapSet=\"RINCON_000001:LF,LF;RINCON_000004:RF,RF\" BootSeq=\"26\" TVConfigurationError=\"0\" HdmiCecAvailable=\"0\" WirelessMode=\"0\" WirelessLeafOnly=\"0\" HasConfiguredSSID=\"0\" ChannelFreq=\"2437\" BehindWifiExtender=\"0\" WifiEnabled=\"1\" Orientation=\"0\" RoomCalibrationState=\"4\" SecureRegState=\"3\" VoiceConfigState=\"0\" MicEnabled=\"0\" AirPlayEnabled=\"1\" IdleState=\"0\" MoreInfo=\"\"/><ZoneGroupMember UUID=\"RINCON_000002\" Location=\"http://10.10.126.65:1400/xml/device_description.xml\" ZoneName=\"Room 2\" Icon=\"x-rincon-roomicon:tvroom\" Configuration=\"1\" SoftwareVersion=\"49.2-63270\" MinCompatibleVersion=\"48.0-00000\" LegacyCompatibleVersion=\"36.0-00000\" HTSatChanMapSet=\"RINCON_000002:LF,RF;RINCON_7828CA0AC90A01400:LR;RINCON_000003:RR\" BootSeq=\"16\" TVConfigurationError=\"1\" HdmiCecAvailable=\"1\" WirelessMode=\"0\" WirelessLeafOnly=\"0\" HasConfiguredSSID=\"0\" ChannelFreq=\"2437\" BehindWifiExtender=\"0\" WifiEnabled=\"1\" Orientation=\"0\" RoomCalibrationState=\"4\" SecureRegState=\"3\" VoiceConfigState=\"0\" MicEnabled=\"0\" AirPlayEnabled=\"1\" IdleState=\"0\" MoreInfo=\"\"><Satellite UUID=\"RINCON_000003\" Location=\"http://10.10.126.69:1400/xml/device_description.xml\" ZoneName=\"Room 2\" Icon=\"x-rincon-roomicon:tvroom\" Configuration=\"1\" Invisible=\"1\" SoftwareVersion=\"49.2-63270\" MinCompatibleVersion=\"48.0-00000\" LegacyCompatibleVersion=\"36.0-00000\" HTSatChanMapSet=\"RINCON_000002:LF,RF;RINCON_000003:RR\" BootSeq=\"27\" TVConfigurationError=\"0\" HdmiCecAvailable=\"0\" WirelessMode=\"0\" WirelessLeafOnly=\"0\" HasConfiguredSSID=\"0\" ChannelFreq=\"5580\" BehindWifiExtender=\"0\" WifiEnabled=\"1\" Orientation=\"0\" RoomCalibrationState=\"5\" SecureRegState=\"3\" VoiceConfigState=\"0\" MicEnabled=\"0\" AirPlayEnabled=\"0\" IdleState=\"0\" MoreInfo=\"\"/></ZoneGroupMember></ZoneGroup></ZoneGroups><VanishedDevices></VanishedDevices></ZoneGroupState>".encodeString() + "</ZoneGroupState>"
        stub(soap(call: GroupTarget.state), soapXml(response))
        
        let groups = try groupRepository
            .getGroups(for: getRooms())
            .toBlocking()
            .single()
        
        XCTAssertEqual(groups.count, 1)
    }
    
}

private extension GroupRepositoryTest {
    
    /* Rooms */
    func getRooms() throws -> [Room] {
        return try ssdpRepository
            .scan(searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1")
            .flatMap(mapSSDPToRooms)
            .toBlocking()
            .single()
    }
    func mapSSDPToRooms(ssdpDevices: [SSDPResponse]) throws -> Single<[Room]> {
        let collection = try ssdpDevices.compactMap(mapSSDPToRoom)
        return Single.zip(collection)
    }
    
    func mapSSDPToRoom(response: SSDPResponse) throws -> Single<Room>? {
        guard let device = try SSDPDevice.map(response) else { return nil }
        return roomRepository.getRoom(device: device)
    }
}
