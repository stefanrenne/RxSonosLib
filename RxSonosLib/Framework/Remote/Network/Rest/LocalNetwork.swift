//
//  LocalNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class LocalNetwork: Network {
    
    let room: Room
    let target: SonosTargetType
    
    init(room: Room, action: SonosTargetType) {
        self.room = room
        self.target = action
    }
    
    internal var request: URLRequest {
        let url = self.room.ip.appendingPathComponent(target.controllUrl)
        var request = URLRequest(url: url)
        request.setValue(self.room.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        request.httpMethod = "POST"
        request.setValue("\"\(target.soapAction)\"", forHTTPHeaderField: "SOAPACTION")
        request.httpBody = target.requestBody.data(using: .utf8)
        return request
    }
    
    func executeRequest() -> Single<[String: String]> {
        return perform(request: request)
            .map(self.openEnvelope())
    }
    
    internal func openEnvelope() -> ((Data) throws -> [String: String]) {
        return { data in
            let xml = AEXMLDocument.create(data)
            let element = xml?["Envelope"]["Body"]["\(self.target.action)Response"]
            
            var soapData: [String: String] = [:]
            element?.children.forEach({ (row) in
                soapData[row.name] = row.string
            })
            
            return soapData
        }
    }
}
