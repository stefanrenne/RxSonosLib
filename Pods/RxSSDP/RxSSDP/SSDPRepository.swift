//
//  SSDPRepository.swift
//  Sample App
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol SSDPRepository {
    
    func scan(broadcastAddress: String, searchTarget: String) -> Observable<[SSDPResponse]>
    
    func scan(broadcastAddresses: [String], searchTarget: String) -> Observable<[SSDPResponse]>
    
}
