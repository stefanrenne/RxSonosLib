//
//  GetDeviceDescriptionNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class GetDeviceDescriptionNetwork: Network {
    
    let location: URL
    
    init(location: URL, usn: String) {
        self.location = location
        super.init(cacheKey: usn)
    }
    
    override func createRequest() -> URLRequest? {
        return URLRequest(url: self.location)
    }
    
}
