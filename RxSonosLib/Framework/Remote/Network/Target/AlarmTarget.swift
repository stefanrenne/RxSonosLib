//
//  AlarmTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum AlarmTarget: SonosTargetType {
    
//    case create
    case list
//    case delete(item: Int)
    
    var action: String {
        switch self {
//        case .create:
//            return "CreateAlarm"
        case .list:
            return "ListAlarms"
//        case .delete:
//            return "DestroyAlarm"
        }
    }
    
    var arguments: String? {
        switch self {
//        case .delete(let item)
//            return "<ID>\(item)</ID>"
//        case .create:
//            return "<StartLocalTime>07:00:00</StartLocalTime><Duration>02:00:00</Duration><Recurrence>ONCE</Recurrence><Enabled>1</Enabled><RoomUUID>RINCON_000001</RoomUUID><ProgramURI>x-rincon-buzzer:0</ProgramURI><ProgramMetaData></ProgramMetaData><PlayMode>SHUFFLE</PlayMode><Volume>25</Volume><IncludeLinkedZones>0</IncludeLinkedZones>"
        default:
            return nil
        }
    }
    
    var controllUrl: String {
        return "/AlarmClock/Control"
    }
    
//    var eventUrl: String {
//        return "/AlarmClock/Event"
//    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:AlarmClock:1"
    }
}
