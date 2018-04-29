//
//  SonosInteractorWithoutGroupsTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 11/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib
import RxSwift
import RxSSDP
import RxBlocking

class SonosInteractorWithoutGroupsTests: XCTestCase {

    override func setUp() {
        RepositoryInjection.shared.contentDirectoryRepository = FakeContentDirectoryRepositoryImpl()
        RepositoryInjection.shared.groupRepository = FakeGroupRepositoryImpl(returnNoGroups: true)
        RepositoryInjection.shared.renderingControlRepository = FakeRenderingControlRepositoryImpl()
        RepositoryInjection.shared.roomRepository = FakeRoomRepositoryImpl()
        RepositoryInjection.shared.ssdpRepository = FakeSSDPRepositoryImpl()
        RepositoryInjection.shared.transportRepository = FakeTransportRepositoryImpl()
        SonosInteractor.shared.allGroups.onNext([])
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
    
    func testItCantSetTheVolumeWhenThereAreNoGroups() {
        XCTAssertThrowsError(try SonosInteractor
            .getActiveGroup()
            .set(volume: 30)
            .toBlocking()
            .toArray()) { error in
                XCTAssertEqual(error.localizedDescription, NSError.sonosLibNoGroupError().localizedDescription)
        }
    }
    
}
