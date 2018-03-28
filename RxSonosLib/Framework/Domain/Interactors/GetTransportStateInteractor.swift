//
//  GetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 28/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSSDP

open class GetTransportStateValues: RequestValues {
    let group: Group
    
    public init(group: Group) {
        self.group = group
    }
}

open class GetTransportStateInteractor: BaseInteractor<GetTransportStateValues, TransportState>  {
    
    let transportRepository: TransportRepository
    
    public init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    override func buildInteractorObservable(requestValues: GetTransportStateValues?) -> Observable<TransportState> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(2)
            .flatMap(self.mapToTransportState(for: masterRoom))
            .distinctUntilChanged({ $0.rawValue == $1.rawValue })
    }
    
    fileprivate func mapToTransportState(for masterRoom: Room) -> (() -> Observable<TransportState>) {
        return {
            return self.transportRepository
                .getTransportState(for: masterRoom)
        }
    }
}
