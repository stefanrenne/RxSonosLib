//
//  GetGroupsInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSSDP
import RxSwift
import RxBlocking

class GetGroupsInteractorTests: XCTestCase {
    
    let ssdpRepository: SSDPRepository = FakeSSDPRepositoryImpl()
    let roomRepository: RoomRepository = FakeRoomRepositoryImpl()
    let groupRepository: GroupRepository = FakeGroupRepositoryImpl()
    
    func testItCanGetGroups() throws {
        let rooms = try FakeRoomRepositoryImpl.allRooms()
        let interactor = GetGroupsInteractor(groupRepository: groupRepository)
        interactor.requestValues = GetGroupsValues(rooms: rooms)
        
        let groups = try interactor
            .get()
            .toBlocking()
            .first()!
        
        XCTAssertEqual(groups.count, 5)
        
        XCTAssertEqual(groups[0].master.uuid, "RINCON_000001")
        XCTAssertEqual(groups[0].slaves.count, 0)
        
        XCTAssertEqual(groups[1].master.uuid, "RINCON_000005")
        XCTAssertEqual(groups[1].slaves.count, 0)
        
        XCTAssertEqual(groups[2].master.uuid, "RINCON_000006")
        XCTAssertEqual(groups[2].slaves.count, 0)
        
        XCTAssertEqual(groups[3].master.uuid, "RINCON_000007")
        XCTAssertEqual(groups[3].slaves.count, 0)
        
        XCTAssertEqual(groups[4].master.uuid, "RINCON_000008")
        XCTAssertEqual(groups[4].slaves.count, 0)
    }
    
    func testItCantGetGroupsWithoutAnRoomObservable() {
        let interactor = GetGroupsInteractor(groupRepository: groupRepository)
        
        XCTAssertThrowsError(try interactor.get().toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.invalidImplementation.localizedDescription)
        }
        
    }
}
