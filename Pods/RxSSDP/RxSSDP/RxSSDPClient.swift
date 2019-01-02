//
//  RxSSDPClient.swift
//  RxSSDP
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class RxSSDPClient {
    
    let port: UInt16
    let method: String
    let request: [String: String]
    
    init(method: String = "M-SEARCH", searchTarget: String, port: UInt16 = 1900) {
        self.port = port
        self.method = method
        self.request = [
            "MAN": "\"ssdp:discover\"",
            "MX": "3",
            "ST": searchTarget
        ]
    }
    
    private var broadcastData: Data? {
        return request.reduce(into: "\(method) * HTTP/1.1\r\n") { (result, row) in
            result.append("\(row.key): \(row.value)\r\n")
        }.data(using: .utf8)
    }
    
    private var broadcastConnection: UDPBroadcastConnection!
    func discover() -> Observable<SSDPResponse> {
        
        return Observable<SSDPResponse>.create({ (observable) -> Disposable in
            self.broadcastConnection = UDPBroadcastConnection(port: self.port) { (_: String, _: Int, response: [UInt8]) -> Void in
                
                if let message = String(bytes: response, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.illegalCharacters).replacingOccurrences(of: "\0", with: ""),
                   let response = SSDPMessageParser(message: message).parse() {
                    
                    observable.onNext(response)
                }
                
            }
            
            if let broadcast = self.broadcastData {
                self.broadcastConnection.sendBroadcast(broadcast)
            }
            
            return Disposables.create()
        })

    }
}
