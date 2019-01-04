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
        CacheManager.shared.clear(removeLongCache: true)
    }
    
    func testItCanGetTheVolume() throws {
        
        stub(soap(call: RenderingControlTarget.getVolume), soapXml("<CurrentVolume>44</CurrentVolume>"))
        
        let volume = try renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 44)
    }
    
    func testItCanGetADefaultVolume() throws {
        
        stub(soap(call: RenderingControlTarget.getVolume), soapXml(""))
        
        let volume = try renderingControlRepository
            .getVolume(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 0)
    }
    
    func testItCanGetTheAverageGroupVolume() throws {
        
        stub(soap(room: firstRoom(), call: RenderingControlTarget.getVolume), soapXml("<CurrentVolume>60</CurrentVolume>"))
        stub(soap(room: try secondRoom(), call: RenderingControlTarget.getVolume), soapXml("<CurrentVolume>20</CurrentVolume>"))
        
        let volume = try renderingControlRepository
            .getVolume(for: secondGroup())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(volume, 40)
    }
    
    func testItCanSetTheGroupVolume() {
        
        stub(soap(call: RenderingControlTarget.setVolume(0)), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .set(volume: 30, for: secondGroup())
            .toBlocking()
            .toArray())
    }
    
    func testItCanMuteTheARoom() {
        
        stub(soap(call: RenderingControlTarget.setMute(true)), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .setMute(room: firstRoom(), enabled: true)
            .toBlocking()
            .toArray())
    }
    
    func testItCanUnMuteTheARoom() {
        
        stub(soap(call: RenderingControlTarget.setMute(false)), soapXml(""))
        
        XCTAssertNoThrow(try renderingControlRepository
            .setMute(room: firstRoom(), enabled: false)
            .toBlocking()
            .toArray())
    }
    
    func testItCantGetTheMuteStateOfARoom() {
        
        stub(soap(call: RenderingControlTarget.getMute), soapXml(""))
        
        XCTAssertThrowsError(try renderingControlRepository.getMute(room: firstRoom()).toBlocking().toArray()) { error in
            XCTAssertEqual(error.localizedDescription, SonosError.noData.localizedDescription)
        }
    }
    
    func testItCanGetUnMutedStateOfARoom() throws {
        
        stub(soap(call: RenderingControlTarget.getMute), soapXml("<CurrentMute>0</CurrentMute>"))
        
        let mute = try renderingControlRepository
            .getMute(room: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertFalse(mute)
    }
    
    func testItCanGetMutedStateOfARoom() throws {
        
        stub(soap(call: RenderingControlTarget.getMute), soapXml("<CurrentMute>1</CurrentMute>"))
        
        let mute = try renderingControlRepository
            .getMute(room: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertTrue(mute)
    }
    
}
