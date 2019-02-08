//
//  InjectionTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 19/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

class InjectionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testItCanProvideTheSSDPRepository() {
        XCTAssertTrue(type(of: Injection.provideSSDPRepository()) == SSDPRepositoryImpl.self)
        
        Injection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideSSDPRepository()) == FakeSSDPRepositoryImpl.self)
    }
    
    func testItCanProvideTheRoomRepository() {
        XCTAssertTrue(type(of: Injection.provideRoomRepository()) == RoomRepositoryImpl.self)
        
        Injection.shared.roomRepository = FakeRoomRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideRoomRepository()) == FakeRoomRepositoryImpl.self)
    }
    
    func testItCanProvideTheGroupRepository() {
        XCTAssertTrue(type(of: Injection.provideGroupRepository()) == GroupRepositoryImpl.self)
        
        Injection.shared.groupRepository = FakeGroupRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideGroupRepository()) == FakeGroupRepositoryImpl.self)
    }
    
    func testItCanProvideTheTransportRepository() {
        XCTAssertTrue(type(of: Injection.provideTransportRepository()) == TransportRepositoryImpl.self)
        
        Injection.shared.transportRepository = FakeTransportRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideTransportRepository()) == FakeTransportRepositoryImpl.self)
    }
    
    func testItCanProvideTheContentDirectoryRepository() {
        XCTAssertTrue(type(of: Injection.provideContentDirectoryRepository()) == ContentDirectoryRepositoryImpl.self)
        
        Injection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideContentDirectoryRepository()) == FakeContentDirectoryRepositoryImpl.self)
    }
    
    func testItCanProvideTheRenderingControlRepository() {
        XCTAssertTrue(type(of: Injection.provideRenderingControlRepository()) == RenderingControlRepositoryImpl.self)
        
        Injection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideRenderingControlRepository()) == FakeRenderingControlRepositoryImpl.self)
    }
    
    func testItCanProvideTheAlarmRepository() {
        XCTAssertTrue(type(of: Injection.provideAlarmRepository()) == AlarmRepositoryImpl.self)
        
        Injection.shared.alarmRepository = FakeAlarmRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideAlarmRepository()) == FakeAlarmRepositoryImpl.self)
    }
    
    func testItCanProvideTheMusicProvidersRepository() {
        XCTAssertTrue(type(of: Injection.provideMusicProvidersRepository()) == MusicProvidersRepositoryImpl.self)
        
        Injection.shared.musicProvidersRepository = FakeMusicProvidersRepositoryImpl()
        XCTAssertTrue(type(of: Injection.provideMusicProvidersRepository()) == FakeMusicProvidersRepositoryImpl.self)
    }
    
}
