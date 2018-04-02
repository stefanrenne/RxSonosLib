//
//  GroupProgressTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 02/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class GroupProgressTests: XCTestCase {
    
    func testItCanMapDataWithHoursToProgress() {
        let data = ["RelTime": "0:00:10", "TrackDuration": "0:01:00"]
        let progress = GroupProgress.map(positionInfo: data)
        
        XCTAssertEqual(progress.time, 10)
        XCTAssertEqual(progress.timeString, "0:10")
        XCTAssertEqual(progress.duration, 60)
        XCTAssertEqual(progress.durationString, "1:00")
    }
    
    func testItCanMapDataWithoutHoursToProgress() {
        let data = ["RelTime": "00:10", "TrackDuration": "01:00"]
        let progress = GroupProgress.map(positionInfo: data)
        
        XCTAssertEqual(progress.time, 10)
        XCTAssertEqual(progress.timeString, "0:10")
        XCTAssertEqual(progress.duration, 60)
        XCTAssertEqual(progress.durationString, "1:00")
    }
    
    func testItCanMapIncorrectDataToProgress() {
        let data = [String: String]()
        let progress = GroupProgress.map(positionInfo: data)
        
        XCTAssertEqual(progress.time, 0)
        XCTAssertEqual(progress.timeString, "0:00")
        XCTAssertEqual(progress.duration, 0)
        XCTAssertEqual(progress.durationString, "0:00")
    }
    
    func testItCanCompareProgress() {
        let progress1 = GroupProgress(time: 0, duration: 0)
        let progress2 = GroupProgress(time: 0, duration: 0)
        XCTAssertEqual(progress1, progress2)
    }
    
    func testItCantCompareProgress() {
        let progress1 = GroupProgress(time: 0, duration: 1)
        let progress2 = GroupProgress(time: 0, duration: 0)
        XCTAssertNotEqual(progress1, progress2)
    }
    
    func testItCanConvertTimeAndDurationToString() {
        let progress = GroupProgress(time: 30, duration: 60)
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.timeString, "0:30")
        XCTAssertEqual(progress.duration, 60)
        XCTAssertEqual(progress.durationString, "1:00")
        XCTAssertEqual(progress.progress, 0.5)
        XCTAssertEqual(progress.remainingTimeString, "-0:30")
    }
    
    func testItCanConvertTimeAndDurationToStringForNulDuration() {
        let progress = GroupProgress(time: 30, duration: 0)
        
        XCTAssertEqual(progress.time, 0)
        XCTAssertEqual(progress.timeString, "0:00")
        XCTAssertEqual(progress.duration, 0)
        XCTAssertEqual(progress.durationString, "0:00")
        XCTAssertEqual(progress.progress, 0.0)
        XCTAssertEqual(progress.remainingTimeString, "0:00")
    }
    
    func testItCanConvertTimeAndDurationToStringForInvalidTime() {
        let progress = GroupProgress(time: 30, duration: 20)
        
        XCTAssertEqual(progress.time, 20)
        XCTAssertEqual(progress.timeString, "0:20")
        XCTAssertEqual(progress.duration, 20)
        XCTAssertEqual(progress.durationString, "0:20")
        XCTAssertEqual(progress.progress, 1.0)
        XCTAssertEqual(progress.remainingTimeString, "0:00")
    }
    
    func testItCanConvertBigTimesToString() {
        let progress = GroupProgress(time: 30, duration: 3640)
        
        XCTAssertEqual(progress.time, 30)
        XCTAssertEqual(progress.timeString, "0:30")
        XCTAssertEqual(progress.duration, 3640)
        XCTAssertEqual(progress.durationString, "1:00:40")
        XCTAssertEqual(progress.progress, 0.01)
        XCTAssertEqual(progress.remainingTimeString, "-1:00:10")
    }
}
