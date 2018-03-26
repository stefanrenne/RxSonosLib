//
//  SSDPRequest+ComplexInit.swift
//  Sample App
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

extension SSDPRequest {
    convenience init(searchTarget: String, broadcastAddress: String, port: UInt16) {
        let dictionary = [
            "HOST": "\(broadcastAddress):\(port)",
            "MAN": "\"ssdp:discover\"",
            "MX": "3",
            "ST": searchTarget
        ]
        
        self.init(method: .Search, dictionary: dictionary)
    }
}
