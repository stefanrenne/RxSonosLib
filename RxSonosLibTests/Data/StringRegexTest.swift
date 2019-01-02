//
//  StringRegexTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class StringRegexTest: XCTestCase {
    
    func testItCanMatchRegexes() throws {
        
        let string1 = "ww.google.com"
        let matches1 = try string1.match(with: "^(?:www.)?([a-z0-9]+).([a-z]+)$")
        XCTAssertNil(matches1)
        
        let string2 = "www.google.com"
        let matches2 = try string2.match(with: "^(?:www.)?([a-z0-9]+).([a-z]+)$")
        XCTAssertEqual(matches2?.count, 2)
        XCTAssertEqual(matches2?[0], "google")
        XCTAssertEqual(matches2?[1], "com")
    }
    
    func testItCanExtractAnUUID() throws {
        let string = "uuid:1234567"
        XCTAssertEqual(try string.extractUUID(), "1234567")
    }
    
    func testItCanSplitUrls() throws {
        let location = "http://192.168.10/test.xml"
        XCTAssertEqual(try location.baseUrl(), "http://192.168.10")
        XCTAssertEqual(try location.urlSuffix(), "/test.xml")
    }
    
    func testItCantSplitAnInvalidUrl() throws {
        let location = "invalid"
        let ip = try location.baseUrl()
        XCTAssertNil(ip)
    }
    
    /* Namespace replace */
    func testItCanCleanupXmlStrings() throws {
        let str1 = "<GetHouseholdIDResponse param1=\"1\"param2=\"2\"param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>"
        XCTAssertEqual(try str1.validateXml(), "<GetHouseholdIDResponse param1=\"1\" param2=\"2\" param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>")
    }
    
    /* Clear Empty String */
    func testItCanClearAnEmptyString() {
        XCTAssertNil("".nilIfEmpty())
    }
    
}
