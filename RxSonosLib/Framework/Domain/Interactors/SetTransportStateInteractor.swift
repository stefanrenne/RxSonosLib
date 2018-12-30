//
//  SetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 14/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetTransportStateValues: RequestValues {
    let group: Group
    let state: TransportState
}

class SetTransportStateInteractor: CompletableInteractor {
    
    var requestValues: SetTransportStateValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: SetTransportStateValues?) -> Completable {
        
        guard let group = requestValues?.group,
              let state = requestValues?.state else {
                return Completable.error(SonosError.invalidImplementation)
        }
        
        switch state {
        case .playing:
            return transportRepository.setPlay(group: group)
        case .paused:
            return transportRepository.setPause(group: group)
        case .stopped:
            return transportRepository.setStop(group: group)
        case .transitioning:
            return Completable.error(SonosError.invalidImplementation)
        }
    }
}
