//
//  DevicePropertiesTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum DevicePropertiesTarget: SonosTargetType {
    
//    case getHouseholdID
//    case getZoneInfo
    
    var action: String {
        switch self {
//        case .getHouseholdID:
//            return "GetHouseholdID"
//        case .getZoneInfo:
//            return "GetZoneInfo"
        }
    }
    
    var arguments: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var controllUrl: String {
        return "/DeviceProperties/Control"
    }
    
    var eventUrl: String {
        return "/DeviceProperties/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:DeviceProperties:1"
    }
}
