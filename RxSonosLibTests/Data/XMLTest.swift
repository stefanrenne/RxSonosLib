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
    
    func testItCanParseXML() throws {
        var description = "<device>"
        description += "<deviceType>urn:schemas-upnp-org:device:ZonePlayer:1</deviceType>"
        description += "<friendlyName>192.168.3.14 - Sonos PLAYBAR</friendlyName>"
        description += "<manufacturer>Sonos, Inc.</manufacturer>"
        description += "<modelNumber>S9</modelNumber>"
        description += "</device>"
        let data = description.data(using: .utf8)
        
        let xml = try AEXMLDocument.create(data!)
        XCTAssertEqual(xml!["device"]["deviceType"].string, "urn:schemas-upnp-org:device:ZonePlayer:1")
        XCTAssertEqual(xml!["device"]["friendlyName"].string, "192.168.3.14 - Sonos PLAYBAR")
        XCTAssertEqual(xml!["device"]["manufacturer"].string, "Sonos, Inc.")
        XCTAssertEqual(xml!["device"]["modelNumber"].string, "S9")
    }
    
    func testItCanParseEmptyXml() throws {
        let description = "<ZoneGroups><ZoneGroup Coordinator=\"RINCON_000001\" ID=\"RINCON_000001:314\"><ZoneGroupMember UUID=\"RINCON_000006\"/><ZoneGroupMember UUID=\"RINCON_000007\" Invisible=\"1\"/><ZoneGroupMember UUID=\"RINCON_000005\"/><ZoneGroupMember UUID=\"RINCON_000001\"><Satellite UUID=\"RINCON_000002\" Invisible=\"1\"/><Satellite UUID=\"RINCON_000003\" Invisible=\"1\"/><Satellite UUID=\"RINCON_000004\"/></ZoneGroupMember><ZoneGroupMember UUID=\"RINCON_000008\"/></ZoneGroup></ZoneGroups><VanishedDevices />"
        let xml = try AEXMLDocument.create(description)
        XCTAssertNotNil(xml)
    }
    
    func testItCantXMLParseAnEmptyDataSet() throws {
        let xml = try AEXMLDocument.create(nil)
        XCTAssertNil(xml)
    }
    
    func testItCantParseIncorrectXML() throws {
        let description = "<device>"
        let data = description.data(using: .utf8)
        
        let xml = try AEXMLDocument.create(data!)
        XCTAssertNil(xml)
    }
    
}
