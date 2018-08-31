//
//  SystemProperties.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum SystemPropertiesTarget: SonosTargetType {
    
//    case getCustomerID
//    case getRoomSerial
    
    var action: String {
        switch self {
//        case .getCustomerID, .getRoomSerial:
//            return "GetString"
        }
    }
    
    var arguments: String? {
        switch self {
//        case .getCustomerID:
//            return "<VariableName>R_CustomerID</VariableName>"
//        case .getRoomSerial:
//            return "<VariableName>R_TrialZPSerial</VariableName>"
        }
    }
    
    var controllUrl: String {
        return "/SystemProperties/Control"
    }
    
    var eventUrl: String {
        return "/SystemProperties/Event"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:SystemProperties:1"
    }
}
