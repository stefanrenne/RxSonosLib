//
//  SonosTargetType.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

protocol SonosTargetType {
    
    var controllUrl: String { get }
    
    var eventUrl: String { get }
    
    var schema: String { get }
    
    var action: String { get }
    
    var arguments: String? { get }
}

extension SonosTargetType {
    
    var soapAction: String {
        return schema + "#" + action
    }
    
    var requestBody: String {
        var bodyString = "<u:\(action) xmlns:u=\"\(schema)\" />"
        if let arguments = arguments {
            bodyString = "<u:\(action) xmlns:u=\"\(schema)\">\(arguments)</u:\(action)>"
        }
        return "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body>\(bodyString)</s:Body></s:Envelope>"
    }
}
