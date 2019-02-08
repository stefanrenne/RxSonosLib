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
        let room = firstRoom()
        let muted = try Observable
            .just(room)
            .getMute()
            .toBlocking()
            .first()!
        
        XCTAssertTrue(muted)
    }
    
    func testItSanGetTheMute() {
        let room = firstRoom()
        XCTAssertNoThrow(try Observable
            .just(room)
            .set(mute: true)
            .toBlocking()
            .toArray())
    }
    
}
