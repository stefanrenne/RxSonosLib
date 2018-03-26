//
//  SSDPResponse+Equatable.swift
//  Sample App
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

extension SSDPResponse: Equatable {
    
    public convenience init(data: [String: String]) {
        self.init(dictionary: data)
    }
    
    public static func ==(lhs: SSDPResponse, rhs: SSDPResponse) -> Bool {
        return lhs.description == rhs.description
    }
}
