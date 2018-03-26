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
        CacheManager.shared.deleteAll()
    }
    
    func testItCanGetGroups() {
        
        var response = "<ZoneGroups>"
            response += "<ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:314\">"
                response += "<ZoneGroupMember UUID=\"RINCON_000006\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000007\" Invisible=\"1\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000005\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000001\">"
                    response += "<Satellite UUID=\"RINCON_000002\" Invisible=\"1\"/>"
                    response += "<Satellite UUID=\"RINCON_000003\" Invisible=\"1\"/>"
                    response += "<Satellite UUID=\"RINCON_000004\"/>"
                response += "</ZoneGroupMember>"
                response += "<ZoneGroupMember UUID=\"RINCON_000008\"/>"
            response += "</ZoneGroup>"
        response += "</ZoneGroups>"
        stub(soap(call: .State), soapXml(response))
        
        let groups = try! groupRepository
            .getGroups(for: self.getRooms())
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
    
    func testItCanNotPerformTheRequestWhenThereAreNoRooms() {
        
        var response = "<ZoneGroups>"
            response += "<ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:314\">"
                response += "<ZoneGroupMember UUID=\"RINCON_000006\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000007\" Invisible=\"1\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000005\"/>"
                response += "<ZoneGroupMember UUID=\"RINCON_000001\">"
                    response += "<Satellite UUID=\"RINCON_000002\" Invisible=\"1\"/>"
                    response += "<Satellite UUID=\"RINCON_000003\" Invisible=\"1\"/>"
                    response += "<Satellite UUID=\"RINCON_000004\" Invisible=\"1\"/>"
                response += "</ZoneGroupMember>"
                response += "<ZoneGroupMember UUID=\"RINCON_000008\"/>"
            response += "</ZoneGroup>"
        response += "</ZoneGroups>"
        stub(soap(call: .State), soapXml(response))
        
        let groups = try! groupRepository
            .getGroups(for: [])
            .toBlocking()
            .single()
        
        XCTAssertEqual(groups, [])
    }
    
}

fileprivate extension GroupRepositoryTest {
    
    /* Rooms */
    fileprivate func getRooms() -> [Room] {
        return try! ssdpRepository
            .scan(broadcastAddresses: ["239.255.255.250", "255.255.255.255"], searchTarget: "urn:schemas-upnp-org:device:ZonePlayer:1", maxTimeSpan: 3, maxCount: 100)
            .flatMap(mapSSDPToRooms())
            .toBlocking()
            .single()
    }
    fileprivate func mapSSDPToRooms() -> (([SSDPResponse]) throws -> Observable<[Room]>) {
        return { ssdpDevices in
            let collection = ssdpDevices.flatMap(self.mapSSDPToRoom())
            return Observable.zip(collection)
        }
    }
    
    fileprivate func mapSSDPToRoom() -> ((SSDPResponse) -> Observable<Room>?) {
        return { response in
            guard let device = SSDPDevice.map(response) else { return nil }
            return self.roomRepository.getRoom(device: device)
        }
    }
}
