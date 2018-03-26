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
    
    public func scan(searchTarget: String) -> Observable<SSDPResponse> {
        return scan(broadcastAddress: "239.255.255.250", searchTarget: searchTarget)
    }
    
    public func scan(broadcastAddress: String, searchTarget: String) -> Observable<SSDPResponse> {
        return RxSSDPClient(broadcastAddress: broadcastAddress, searchTarget: searchTarget)
            .discover()
    }
    
    public func scan(broadcastAddress: String,  maxTimeSpan: RxTimeInterval, maxCount: Int) -> Observable<[SSDPResponse]> {
        return scan(broadcastAddress: broadcastAddress, searchTarget: "239.255.255.250", maxTimeSpan: maxTimeSpan, maxCount: maxCount)
    }
    
    public func scan(broadcastAddresses: [String], maxTimeSpan: RxTimeInterval, maxCount: Int) -> Observable<[SSDPResponse]> {
        return scan(broadcastAddresses: broadcastAddresses, searchTarget: "239.255.255.250", maxTimeSpan: maxTimeSpan, maxCount: maxCount)
    }
    
    public func scan(broadcastAddress: String, searchTarget: String, maxTimeSpan: RxTimeInterval, maxCount: Int) -> Observable<[SSDPResponse]> {
        return scan(broadcastAddress: broadcastAddress, searchTarget: searchTarget)
        .buffer(timeSpan: maxTimeSpan, count: maxCount, scheduler: SerialDispatchQueueScheduler(qos: .userInitiated))
    }
    
    public func scan(broadcastAddresses: [String], searchTarget: String, maxTimeSpan: RxTimeInterval, maxCount: Int) -> Observable<[SSDPResponse]> {
        let collection = broadcastAddresses.map({ self.scan(broadcastAddress: $0, searchTarget: searchTarget, maxTimeSpan: maxTimeSpan, maxCount: maxCount) })
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
