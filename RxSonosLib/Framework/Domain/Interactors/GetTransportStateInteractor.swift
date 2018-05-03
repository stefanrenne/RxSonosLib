//
//  GetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 28/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetTransportStateValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetTransportStateInteractor<T: GetTransportStateValues>: Interactor {
    
    let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(requestValues: GetTransportStateValues?) -> Observable<TransportState> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(SonosSettings.shared.renewGroupTransportStateTimer)
            .flatMap(self.mapToTransportState(for: masterRoom))
            .distinctUntilChanged({ $0.rawValue == $1.rawValue })
    }
    
    fileprivate func mapToTransportState(for masterRoom: Room) -> ((Int) -> Observable<TransportState>) {
        return { _ in
            return self.transportRepository
                .getTransportState(for: masterRoom)
        }
    }
}
