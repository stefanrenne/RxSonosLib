//
//  RenderingControlRepositoryTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Mockingjay
@testable import RxSonosLib

class RenderingControlRepositoryTests: XCTestCase {
    
    let renderingControlRepository: RenderingControlRepository = RenderingControlRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.deleteAll()
    }
    
    func testItCanGetTheVolume() {
        
        stub(soap(call: .getVolume), soapXml("<CurrentVolume>44</CurrentVolume>"))
        
        let volume = try! renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 44)
    }
    
    func testItCanGetADefaultVolume() {
        
        stub(soap(call: .getVolume), soapXml(""))
        
        let volume = try! renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 0)
    }
    
    func testItCanGetTheAverageGroupVolume() {
        
        stub(soap(room: firstRoom(), call: .getVolume), soapXml("<CurrentVolume>60</CurrentVolume>"))
        stub(soap(room: secondRoom(), call: .getVolume), soapXml("<CurrentVolume>20</CurrentVolume>"))
        
        let volume = try! renderingControlRepository
            .getVolume(for: secondGroup())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 40)
    }
    
    func testItCanSetTheGroupVolume() {
        
        stub(soap(call: .setVolume(0)), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .set(volume: 30, for: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanPlayTheActiveGroupTrack() {
        
        stub(soap(call: .play), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .setPlay(group: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanPauseTheActiveGroupTrack() {
        
        stub(soap(call: .pause), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .setPause(group: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanStopTheActiveGroupTrack() {
        
        stub(soap(call: .stop), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .setStop(group: secondGroup())
            .toBlocking()
            .toArray())
    }
    
}
