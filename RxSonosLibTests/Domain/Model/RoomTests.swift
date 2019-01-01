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
        resetToFakeRepositories()
        super.setUp()
    }
    
    override func tearDown() {
        resetToRealRepositories()
        super.tearDown()
    }
    
    func testItCanGetTheMute() throws {
        let mock = RepositoryInjection.shared.renderingControlRepository as! FakeRenderingControlRepositoryImpl
        mock.numberSetMuteCalls = 0
        mock.numberGetMuteCalls = 0
        
        let room = firstRoom()
        let muted = try Observable
            .just(room)
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
        _ = Observable
            .just(room)
            .set(mute: true)
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(mock.numberSetMuteCalls, 1)
        XCTAssertEqual(mock.numberGetMuteCalls, 0)
    }
    
}
