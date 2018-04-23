//
//  RoomTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 21/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
import RxSwift
@testable import RxSonosLib

class RoomTests: XCTestCase {
    
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
    
    func testItCanGetTheMute() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let room = firstRoom()
        let muted = try! room
            .getMute()
            .toBlocking()
            .first()!
        
        XCTAssertTrue(muted)
        XCTAssertEqual(mock.numberSetMuteCalls, 0)
        XCTAssertEqual(mock.numberGetMuteCalls, 1)
    }
    
    func testItSanGetTheMute() {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let room = firstRoom()
        let counter = try! room
            .set(mute: true)
            .map({ _ in
                return mock.numberSetMuteCalls
            })
            .toBlocking()
            .first()!
        XCTAssertEqual(counter, 1)
        XCTAssertEqual(mock.numberGetMuteCalls, 0)
    }
    
}
