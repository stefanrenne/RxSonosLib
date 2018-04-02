//
//  TimeConvertTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class TimeConvertTests: XCTestCase {
    
    func testItCanConvertTimeToSeconds() {
        let timeString = "00:04:03"
        XCTAssertEqual(timeString.timeToSeconds(), 243)
    }
    
    func testItCanConvertTimeStringsWithoutHours() {
        let timeString = "04:03"
        XCTAssertEqual(timeString.timeToSeconds(), 243)
    }
    
    func testItCanConvertIncorrectFormattedTimeStrings() {
        let timeString = "4:3"
        XCTAssertEqual(timeString.timeToSeconds(), 243)
    }
    
    func testItCanNotConvertAnIncorrectString() {
        let timeString = "in:correct:string"
        XCTAssertEqual(timeString.timeToSeconds(), 0)
    }
    
}
