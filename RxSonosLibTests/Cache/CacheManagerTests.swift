//
//  CacheManagerTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import RxSSDP
@testable import RxSonosLib

class CacheManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CacheManager.shared.clear(removeLongCache: true)
    }
    
    func testItCanSaveData() {
        
        let key = CacheKey.trackImage
        let data = "random".data(using: .utf8)!
        
        let object1: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object1)
        
        CacheManager.shared.set(data, for: key)
        
        let cachedData: Data? = CacheManager.shared.get(for: key)
        XCTAssertNotNil(cachedData)
        
        let object2: String? = String(data: cachedData!, encoding: .utf8)
        XCTAssertEqual(object2, "random")

    }
    
    func testItCantSaveDataForAnInvalidKey() {
        
        let key = CacheKey.trackImage
        
        let object2: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object2)
    }
    
    func testItCanGetDataStoredInLongStorage() {
        
        let key = CacheKey.ssdp
        let data = "random".data(using: .utf8)!
        
        let object1: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object1)
        
        CacheManager.shared.set(data, for: key)
        
        CacheManager.shared.clear(removeLongCache: false)
        
        let cachedData: Data? = CacheManager.shared.get(for: key)
        XCTAssertNotNil(cachedData)
        
        let object2: String? = String(data: cachedData!, encoding: .utf8)
        XCTAssertEqual(object2, "random")
    }
    
    func testItCantGetDataStoredInStortStorage() {
        
        let key = CacheKey.trackImage
        let data = "random".data(using: .utf8)!
        
        let object1: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object1)
        
        CacheManager.shared.set(data, for: key)
        
        CacheManager.shared.clear(removeLongCache: false)
        
        let cachedData: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(cachedData)
    }
    
    func testItCanSaveObjects() throws {
        let key = CacheKey.trackImage
        let object = SSDPResponse(data: ["key": "value"])
        
        try? CacheManager.shared.set(object: object, for: key)
        
        XCTAssertEqual(CacheManager.shared.getObject(for: key), object)
    }
    
}
