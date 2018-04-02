//
//  CacheManagerTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class CacheManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CacheManager.shared.deleteAll()
    }
    
    override func tearDown() {
        CacheManager.shared.deleteAll()
        super.tearDown()
    }
    
    func testItCanSaveData() {
        
        let key = "randomKey"
        let data = "random".data(using: .utf8)!
        
        let object1: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object1)
        
        CacheManager.shared.set(data, for: key)
        let object2: String? = String(data: CacheManager.shared.get(for: key)!, encoding: .utf8)
        XCTAssertEqual(object2, "random")
        
    }
    
    func testItCantSaveDataForAnInvalidKey() {
        
        let key: String? = nil
        let data = "random".data(using: .utf8)!
        
        let object1: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object1)
        
        CacheManager.shared.set(data, for: key)
        let object2: Data? = CacheManager.shared.get(for: key)
        XCTAssertNil(object2)
    }
}
