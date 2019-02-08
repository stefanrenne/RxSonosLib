//
//  SonosInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSwift
import RxBlocking

class SonosInteractorTests: XCTestCase {
    
    override func setUp() {
        resetToFakeRepositories()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        resetToRealRepositories()
    }
    
    func testItCanProvideTheGroupsObservable() throws {
        let groups = try SonosInteractor
            .getAllGroups()
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
    
    func testItCanAutomaticallySetTheActiveGroupToTheFirstFoundGroup() throws {
        SonosInteractor.shared.activeGroup.onNext(nil)
        try SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        
        XCTAssertEqual(try SonosInteractor.shared.activeGroup.value()!, firstGroup())
    }
    
    func testItCanAutomaticallySetTheActiveGroupWhenTheOldOneDoesntExist() throws {
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        try SonosInteractor.shared.allGroups.onNext([thirdGroup()])
        
        XCTAssertEqual(try SonosInteractor.shared.activeGroup.value()!, try thirdGroup())
    }
    
    func testItCanGetTheActiveGroup() throws {
        try SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try SonosInteractor.getActiveGroup().toBlocking().first(), firstGroup())
        
        try SonosInteractor.shared.activeGroup.onNext(secondGroup())
        XCTAssertEqual(try SonosInteractor.getActiveGroup().toBlocking().first(), try secondGroup())
    }
    
    func testItCanSetTheActiveGroup() throws {
        try SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try SonosInteractor.shared.activeGroup.value()!, firstGroup())
        
        try SonosInteractor.setActive(group: secondGroup())
        XCTAssertEqual(try SonosInteractor.shared.activeGroup.value()!, try secondGroup())
    }
    
    func testItCanGetAllMusicProviders() throws {
        let musicProvidersRepository = Injection.shared.musicProvidersRepository as? FakeMusicProvidersRepositoryImpl
        XCTAssertNotNil(musicProvidersRepository)
        XCTAssertEqual(musicProvidersRepository?.getMusicProvidersCount.value, 0)
        
        let musicServices = try SonosInteractor
            .getAllMusicProviders()
            .toBlocking()
            .first()!
        XCTAssertEqual(musicServices.count, 4)
        XCTAssertEqual(musicProvidersRepository?.getMusicProvidersCount.value, 1)
    }
    
    func testItCanGetAllAlarms() throws {
        let alarms = try SonosInteractor
            .getAllAlarms()
            .toBlocking()
            .first()!
        XCTAssertEqual(alarms.count, 1)
    }
    
    func testItCanGetTheActiveGroupValue() {
        SonosInteractor.shared.activeGroup.onNext(nil)
        XCTAssertNil(SonosInteractor.shared.activeGroupValue())
        
        let newGroup = firstGroup()
        SonosInteractor.shared.activeGroup.onNext(newGroup)
        XCTAssertEqual(SonosInteractor.shared.activeGroupValue(), newGroup)
        
        SonosInteractor.shared.activeGroup.onError(SonosError.noData)
        XCTAssertNil(SonosInteractor.shared.activeGroupValue())
    }
    
}
