//
//  FakeAlarmRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxSonosLib

class FakeAlarmRepositoryImpl: AlarmRepository {
    
    let numberListCounter = AtomicInteger()
    func getAlarmItems(for room: Room) -> Single<[Alarm]> {
        numberListCounter.increment()
        
        let alarm1 = Alarm(id: 1, enabled: true, startTime: "02:00:00", duration: "01:00:00", recurrence: .once, programURI: "x-sonosapi-stream6712?sid=254&flags=32", playMode: .shuffle, includeLinkedZones: false, roomUUID: "RINCON_000001", metaData: ["class": "object.item.audioItem.audioBroadcast", "desc": "SA_RINCON65031_", "descnameSpace": "urnchemas-rinconnetworks-com:metadata-1-0/", "descid": "cdudn", "title": "538"], volume: 50)
        return Single.just([alarm1])
    }
}
