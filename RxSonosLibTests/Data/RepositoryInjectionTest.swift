//
//  RepositoryInjectionTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 19/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

class RepositoryInjectionTest: XCTestCase {
    
    func testItCanProvideTheSSDPRepository() {
        XCTAssertTrue(type(of: RepositoryInjection.provideSSDPRepository()) == SSDPRepositoryImpl.self)
        
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        XCTAssertTrue(type(of: RepositoryInjection.provideSSDPRepository()) == FakeSSDPRepositoryImpl.self)
    }
    
    func testItCanProvideTheRoomRepository() {
        XCTAssertTrue(type(of: RepositoryInjection.provideRoomRepository()) == RoomRepositoryImpl.self)
        
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        XCTAssertTrue(type(of: RepositoryInjection.provideRoomRepository()) == FakeRoomRepositoryImpl.self)
    }
    
    func testItCanProvideTheGroupRepository() {
        XCTAssertTrue(type(of: RepositoryInjection.provideGroupRepository()) == GroupRepositoryImpl.self)
        
        RepositoryInjection.shared.groupRepository = FakeGroupRepositoryImpl()
        XCTAssertTrue(type(of: RepositoryInjection.provideGroupRepository()) == FakeGroupRepositoryImpl.self)
    }
    
    func testItCanProvideTheTransportRepository() {
        XCTAssertTrue(type(of: RepositoryInjection.provideTransportRepository()) == TransportRepositoryImpl.self)
        
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        XCTAssertTrue(type(of: RepositoryInjection.provideTransportRepository()) == FakeTransportRepositoryImpl.self)
    }
    
}
