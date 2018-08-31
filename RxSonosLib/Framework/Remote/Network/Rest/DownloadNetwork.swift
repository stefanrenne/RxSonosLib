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
    
    func request(download location: URL) -> Single<Data> {
        return perform(request: URLRequest(url: location))
    }
    
}
