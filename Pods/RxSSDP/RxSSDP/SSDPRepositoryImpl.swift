//
//  SSDPRepositoryImpl.swift
//  RxSSDP
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class SSDPRepositoryImpl: SSDPRepository {
    
    public init() { }
    
    public func scan(searchTarget: String) -> Single<[SSDPResponse]> {
        return RxSSDPClient(searchTarget: searchTarget)
            .discover()
            .buffer(timeSpan: SSDPSettings.shared.maxBufferTime, count: SSDPSettings.shared.maxBufferdItems, scheduler: SSDPSettings.shared.scheduler)
            .take(1)
            .asSingle()
    }
}
