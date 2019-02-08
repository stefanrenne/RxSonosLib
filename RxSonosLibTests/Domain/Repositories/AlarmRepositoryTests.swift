//
//  AlarmRepositoryTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Mockingjay
@testable import RxSonosLib

class AlarmRepositoryTests: XCTestCase {
    
    private let alarmRepository: AlarmRepository = AlarmRepositoryImpl()
    
    override func setUp() {
        CacheManager.shared.clear(removeLongCache: true)
    }
    
    func testItCanGetAlarmItems() throws {
        stub(soap(call: AlarmTarget.list), soapXml("<CurrentAlarmList>\(alarmList.encodeString())</CurrentAlarmList><CurrentAlarmListVersion>RINCON_000E58B4AE9601400:834</CurrentAlarmListVersion>"))
        
        let alarms = try alarmRepository
            .getAlarmItems(for: firstRoom())
            .toBlocking()
            .first()!
        
        XCTAssertEqual(alarms.count, 1)
        XCTAssertEqual(alarms[0].id, 3)
        XCTAssertEqual(alarms[0].enabled, false)
        XCTAssertEqual(alarms[0].startTime, "09:00:00")
        XCTAssertEqual(alarms[0].duration, "01:00:00")
        XCTAssertEqual(alarms[0].recurrence, .once)
        XCTAssertEqual(alarms[0].programURI, "x-sonosapi-stream6712?sid=254&flags=32")
        XCTAssertEqual(alarms[0].playMode, .shuffle)
        XCTAssertEqual(alarms[0].includeLinkedZones, true)
        XCTAssertEqual(alarms[0].roomUUID, "RINCON_000001")
        XCTAssertEqual(alarms[0].metaData, ["class": "object.item.audioItem.audioBroadcast", "desc": "SA_RINCON65031_", "descnameSpace": "urnchemas-rinconnetworks-com:metadata-1-0/", "descid": "cdudn", "title": "538"])
        XCTAssertEqual(alarms[0].volume, 4)
        
    }

}

private extension AlarmRepositoryTests {
    
    var alarmList: String {
        return  "<Alarms><Alarm ID=\"3\" StartTime=\"09:00:00\" Duration=\"01:00:00\" Recurrence=\"ONCE\" Enabled=\"0\" RoomUUID=\"RINCON_000001\" ProgramURI=\"x-sonosapi-stream6712?sid=254&amp;flags=32\" ProgramMetaData=\"&lt;DIDL-Lite xmlndc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlnupnp=&quot;urnchemas-upnp-org:metadata-1-0/upnp/&quot; xmlnr=&quot;urnchemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urnchemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;R:0/0/2&quot; parentID=&quot;R:0/0&quot; restricted=&quot;true&quot;&gt;&lt;dc:title&gt;538&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.audioBroadcast&lt;/upnp:class&gt;&lt;desc id=&quot;cdudn&quot; nameSpace=&quot;urnchemas-rinconnetworks-com:metadata-1-0/&quot;&gt;SA_RINCON65031_&lt;/desc&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;\" PlayMode=\"SHUFFLE\" Volume=\"4\" IncludeLinkedZones=\"1\"/></Alarms>"
    }
    
}
