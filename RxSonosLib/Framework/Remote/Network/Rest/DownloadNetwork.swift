//
//  DownloadNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class DownloadNetwork: Network {
    
    private let request: URLRequest
    
    init(location: URL) {
        request = URLRequest(url: location)
    }
    
    func executeRequest() -> Single<Data> {
        return perform(request: request)
    }
    
}
