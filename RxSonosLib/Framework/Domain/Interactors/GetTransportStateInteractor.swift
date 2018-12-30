//
//  GetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 28/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetTransportStateValues: RequestValues {
    let group: Group
}

class GetTransportStateInteractor: ObservableInteractor {
    
    var requestValues: GetTransportStateValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: GetTransportStateValues?) -> Observable<TransportState> {
        
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
                .asObservable()
        }
    }
}
