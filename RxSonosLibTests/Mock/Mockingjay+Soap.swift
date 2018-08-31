//
//  Mockingjay+Soap.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import Mockingjay
@testable import RxSonosLib


public func soap(room: Room? = nil, call: SonosTargetType) -> (_ request: URLRequest) -> Bool {
    return { (request: URLRequest) in
        
        let ipMatch = (room != nil) ? request.url?.absoluteString.baseUrl() == room?.ip.absoluteString : true
        let soapActionMatch = request.allHTTPHeaderFields?["SOAPACTION"]?.replacingOccurrences(of: "\"", with: "") == call.soapAction
        
        if soapActionMatch && ipMatch {
            return Mockingjay.uri(call.controllUrl)(request)
        }
        
        return false
    }
}

public func soapXml(_ response: String, status: Int = 200, headers: [String:String] = [:]) -> (_ request: URLRequest) -> Response {
    return { (request: URLRequest) in
        
        let soapAction = request.allHTTPHeaderFields!["SOAPACTION"]!.replacingOccurrences(of: "\"", with: "").components(separatedBy: "#")
        let scheme = soapAction.first!
        let action = soapAction.last!
        
        var content = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
        content += "<s:Body>"
        content += "<u:\(action)Response xmlns:u=\"\(scheme)\">"
        content += response
        content += "</u:\(action)Response>"
        content += "</s:Body>"
        content += "</s:Envelope>"
        
        let data = content.data(using: .utf8)!
        return http(status, headers: headers, download: .content(data))(request)
    }
}

public func xml(_ response: String, status: Int = 200, headers: [String:String] = [:]) -> (_ request: URLRequest) -> Response {
    return { (request: URLRequest) in
        let xml = ("<?xml version=\"1.0\" encoding=\"UTF-8\"?><root xmlns=\"urn:schemas-upnp-org:device-1-0\">" + response + "</root>")
        return http(status, headers: headers, download: .content(xml.data(using: .utf8)!))(request)
    }
}

extension String {
    func encodeString() -> String {
        return self.replacingOccurrences(of: "&", with: "&amp;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;").replacingOccurrences(of: "\"", with: "&quot;")
    }
}
