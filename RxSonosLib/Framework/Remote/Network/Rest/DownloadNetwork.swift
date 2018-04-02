//
//  DownloadNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class DownloadNetwork: Network {
    
    let location: URL
    
    init(location: URL, cacheKey: String? = nil) {
        self.location = location
        super.init(cacheKey: cacheKey)
    }
    
    override func createRequest() -> URLRequest? {
        return URLRequest(url: self.location)
    }
    
}
