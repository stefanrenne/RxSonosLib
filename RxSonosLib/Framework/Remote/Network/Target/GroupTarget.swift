//
//  GroupTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum GroupTarget: SonosTargetType {
    
    case state
//    case groupAttributes
    
    var action: String {
        switch self {
        case .state:
            return "GetZoneGroupState"
//        case .groupAttributes:
//            return "GetZoneGroupAttributes"
        }
    }
    
    var arguments: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var controllUrl: String {
        return "/ZoneGroupTopology/Control"
    }
    
//    var eventUrl: String {
//        return "/ZoneGroupTopology/Event"
//    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:ZoneGroupTopology:1"
    }
    
}
