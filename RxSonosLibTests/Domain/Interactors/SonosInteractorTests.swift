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
import RxSSDP
import RxBlocking

class SonosInteractorTests: XCTestCase {
    
    override func setUp() {
        self.reset()
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
    
    func testItCanProvideTheGroupsObservable() {
        
        reset()
        
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
        
        reset()
        SonosInteractor.shared.activeGroup.onNext(nil)
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, firstGroup())
    }
    
    func testItCanAutomaticallySetTheActiveGroupWhenTheOldOneDoesntExist() {
        
        reset()
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        SonosInteractor.shared.allGroups.onNext([thirdGroup()])
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, thirdGroup())
    }
    
    func testItCanGetTheActiveGroup() {
        
        reset()
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try! SonosInteractor.getActiveGroup().toBlocking().first(), firstGroup())
        
        SonosInteractor.shared.activeGroup.onNext(secondGroup())
        XCTAssertEqual(try! SonosInteractor.getActiveGroup().toBlocking().first(), secondGroup())
    }
    
    func testItCanSetTheActiveGroup() {
        
        reset()
        SonosInteractor.shared.allGroups.onNext([firstGroup(), secondGroup()])
        SonosInteractor.shared.activeGroup.onNext(firstGroup())
        
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, firstGroup())
        
        SonosInteractor.setActive(group: secondGroup())
        XCTAssertEqual(try! SonosInteractor.shared.activeGroup.value()!, secondGroup())   
    }
    
}

fileprivate extension SonosInteractorTests {
    
    func reset() {
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        let groupRepository = FakeGroupRepositoryImpl()
        RepositoryInjection.shared.groupRepository = groupRepository
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        SonosInteractor.shared.allGroups.onNext(groupRepository.allGroups)
        SonosInteractor.shared.activeGroup.onNext(groupRepository.allGroups.first)
    }
}
