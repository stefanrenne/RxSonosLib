//
//  XMLTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 19/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
import AEXML
@testable import RxSonosLib

class XMLTest: XCTestCase {
    
    func testItCanParseXML() {
        var description = "<device>"
        description += "<deviceType>urn:schemas-upnp-org:device:ZonePlayer:1</deviceType>"
        description += "<friendlyName>192.168.3.14 - Sonos PLAYBAR</friendlyName>"
        description += "<manufacturer>Sonos, Inc.</manufacturer>"
        description += "<modelNumber>S9</modelNumber>"
        description += "</device>"
        let data = description.data(using: .utf8)
        
        let xml = AEXMLDocument.create(data!)
        XCTAssertEqual(xml!["device"]["deviceType"].string, "urn:schemas-upnp-org:device:ZonePlayer:1")
        XCTAssertEqual(xml!["device"]["friendlyName"].string, "192.168.3.14 - Sonos PLAYBAR")
        XCTAssertEqual(xml!["device"]["manufacturer"].string, "Sonos, Inc.")
        XCTAssertEqual(xml!["device"]["modelNumber"].string, "S9")
    }
    
    func testItCantXMLParseAnEmptyDataSet() {
        let xml = AEXMLDocument.create(nil)
        XCTAssertNil(xml)
    }
    
    func testItCantParseIncorrectXML() {
        let description = "<device>"
        let data = description.data(using: .utf8)
        
        let xml = AEXMLDocument.create(data!)
        XCTAssertNil(xml)
    }
    
}
