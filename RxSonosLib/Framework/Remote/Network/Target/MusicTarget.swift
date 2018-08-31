//
//  MusicTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum MusicTarget: SonosTargetType {
    
    case listAvailableServices
//    case getSessionId(Int, String)
    
    var action: String {
        switch self {
        case .listAvailableServices:
            return "ListAvailableServices"
//        case .getSessionId:
//            return "GetSessionId"
        }
    }
    
    var arguments: String? {
        switch self {
//        case .getSessionId(let serviceId, let username):
//            return "<ServiceId>\(serviceId)</ServiceId><Username>\(username)</Username>"
        default:
            return nil
        }
    }
    
    var controllUrl: String {
        return "/MusicServices/Control"
    }
    
//    var eventUrl: String {
//        return "/MusicServices/Event"
//    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:MusicServices:1"
    }
}
