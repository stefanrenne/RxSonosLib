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
        self.resetToFakeRepositories()
        super.setUp()
    }
    
    override func tearDown() {
        resetToRealRepositories()
        super.tearDown()
    }
    
    func testItCanProvideTheGroupsObservable() {
        
        resetToFakeRepositories()

        let groups = try! SonosInteractor
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
    
    func testItCanAutomaticallySetTheActiveGroupToTheFirstFoundGroup() {
        
        resetToFakeRepositories()
        SonosInteractor.shared.activeGroup.onNext(nil)
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, firstGroup())
    }
    
    func testItCanAutomaticallySetTheActiveGroupWhenTheOldOneDoesntExist() {
        
        resetToFakeRepositories()
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        SonosInteractor.shared.allGroups.onNext([thirdGroup()])
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, thirdGroup())
    }
    
    func testItCanGetTheActiveGroup() {
        
        resetToFakeRepositories()
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try! SonosInteractor.getActiveGroup().toBlocking().first(), firstGroup())
        
        SonosInteractor.shared.activeGroup.onNext(secondGroup())
        XCTAssertEqual(try! SonosInteractor.getActiveGroup().toBlocking().first(), secondGroup())
    }
    
    func testItCanSetTheActiveGroup() {
        
        resetToFakeRepositories()
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, firstGroup())
        
        SonosInteractor.setActive(group: secondGroup())
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, secondGroup())   
    }
    
    func testItCanGetAllMusicServices() {
        
        resetToFakeRepositories()
        let musicServicesRepository = RepositoryInjection.shared.musicServicesRepository as! FakeMusicServicesRepositoryImpl
        XCTAssertEqual(musicServicesRepository.getMusicServicesCount, 0)
        
        let musicServices = try! SonosInteractor
            .getAllMusicServices()
            .toBlocking()
            .first()!
        XCTAssertEqual(musicServices.count, 4)
        XCTAssertEqual(musicServicesRepository.getMusicServicesCount, 1)
        
    }
    
}
