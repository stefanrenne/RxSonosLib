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
    
    /* Music Services */
    func testItCanGetAnDefaultMusicServiceTypeForUnknownUrls() {
        let url = "unknown"
        XCTAssertEqual(url.musicServiceFromUrl(), MusicServiceType.unknown)
    }
    
    func testItCanGetTheMusicServiceTypeSpotifyFromAnUrl() {
        let url = "x-sonos-spotify:spotify%3atrack%3a5HR4CYT5nPpFy8m9wJQgrr?sid=9&flags=0&sn=6"
        XCTAssertEqual(url.musicServiceFromUrl(), MusicServiceType.spotify)
    }
    func testItCanGetTheMusicServiceTypeTuneInFromAnUrl() {
        let url1 = "x-rincon-mp3radio://vip-icecast.538.lw.triple-it.nl/RADIO538_MP3"
        XCTAssertEqual(url1.musicServiceFromUrl(), MusicServiceType.tunein)
        
        let url2 = "aac://http://19143.live.streamtheworld.com:80/SKYRADIOAAC_SC?TGT=TuneIn&DIST=TuneIn"
        XCTAssertEqual(url2.musicServiceFromUrl(), MusicServiceType.tunein)
    }
    func testItCanDetectTVFromAnUrl() {
        let url = "x-sonos-htastream:RINCON_000E58B4AE9601400:spdif"
        XCTAssertEqual(url.musicServiceFromUrl(), MusicServiceType.tv)
    }
    
    /* Namespace replace */
    func testItCanCleanupXmlStrings() {
        let str1 = "<GetHouseholdIDResponse param1=\"1\"param2=\"2\"param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>"
        XCTAssertEqual(str1.validateXml(), "<GetHouseholdIDResponse param1=\"1\" param2=\"2\" param3=\"3\"><CurrentHouseholdID>SONOSID</CurrentHouseholdID></GetHouseholdIDResponse>")
    }
    
    /* Clear Empty String */
    func testItCanClearAnEmptyString() {
        XCTAssertNil("".nilIfEmpty())
    }
    
}
