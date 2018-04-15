//
//  SSDPRepositoryImpl.swift
//  Sample App
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class SSDPRepositoryImpl: SSDPRepository {
    
    public init() { }
    
    public func scan(broadcastAddress: String, searchTarget: String) -> Observable<[SSDPResponse]> {
        return RxSSDPClient(broadcastAddress: broadcastAddress, searchTarget: searchTarget)
            .discover()
            .buffer(timeSpan: SSDPSettings.shared.maxBufferTime, count: SSDPSettings.shared.maxBufferdItems, scheduler: SSDPSettings.shared.scheduler)
            .take(1)
    }
    
    public func scan(broadcastAddresses: [String], searchTarget: String) -> Observable<[SSDPResponse]> {
        let collection = broadcastAddresses.map({ self.scan(broadcastAddress: $0, searchTarget: searchTarget) })
        return Observable.zip(collection, self.zipSSDPResponses())
    }
}

fileprivate extension SSDPRepositoryImpl {
    fileprivate func zipSSDPResponses() -> (([[SSDPResponse]]) -> [SSDPResponse]) {
        return { responses in
            return responses.reduce([], { (result, row) -> [SSDPResponse] in
                let newElements = row.filter({ !result.contains($0) })
                return result + newElements
            })
        }
    }
}
