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

class LocalNetwork<Target: SonosTargetType>: Network {
    
    func request(_ action: Target, on room: Room) -> Single<[String: String]> {
        let url = room.ip.appendingPathComponent(action.controllUrl)
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(room.userAgent, forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        urlRequest.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("\"\(action.soapAction)\"", forHTTPHeaderField: "SOAPACTION")
        urlRequest.httpBody = action.requestBody.data(using: .utf8)
        
        return perform(request: urlRequest)
            .map(self.openEnvelope(for: action))
    }
    
    internal func openEnvelope(for target: Target) -> ((Data) throws -> [String: String]) {
        return { data in
            let xml = AEXMLDocument.create(data)
            let element = xml?["Envelope"]["Body"]["\(target.action)Response"]
            
            var soapData: [String: String] = [:]
            element?.children.forEach({ (row) in
                soapData[row.name] = row.string
            })
            
            return soapData
        }
    }
}
