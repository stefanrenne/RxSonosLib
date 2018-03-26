//
//  StringRegexTest.swift
//  RxSonosLibTests
//
//  Created by info@stefanrenne.nl on 17/11/16.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class StringRegexTest: XCTestCase {
    
    func testItCanMatchRegexes() {
        
        let string1 = "ww.google.com"
        let matches1 = string1.match(with: "^(?:www.)?([a-z0-9]+).([a-z]+)$")
        XCTAssertNil(matches1)
        
        let string2 = "www.google.com"
        let matches2 = string2.match(with: "^(?:www.)?([a-z0-9]+).([a-z]+)$")
        XCTAssertNotNil(matches2)
        
        let site = matches2?.resultForString(string2, index: 1)
        XCTAssertEqual(site, "google")
        
        let unknownIndex = matches2?.resultForString(string2, index: 3)
        XCTAssertNil(unknownIndex)
    }
    
    func testItCanExtractAnUUID() {
        let string = "uuid:1234567"
        XCTAssertEqual(string.extractUUID(), "1234567")
    }
    
    func testItCanSplitUrls() {
        let location = "http://192.168.10/test.xml"
        XCTAssertEqual(location.baseUrl(), "http://192.168.10")
        XCTAssertEqual(location.urlSuffix(), "/test.xml")
    }
    
    func testItCantSplitAnInvalidUrl() {
        let location = "invalid"
        let ip = location.baseUrl()
        XCTAssertNil(ip)
    }
    
    /* Namespace replace */
    func testItCanCleanupXmlStrings() {
        let str1 = "<GetHouseholdIDResponse param1=\"1\"param2=\"2\"param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>"
        XCTAssertEqual(str1.validateXml(), "<GetHouseholdIDResponse param1=\"1\" param2=\"2\" param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>")
    }
    
}
