//
//  SetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 14/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class SetTransportStateValues: RequestValues {
    let group: Group
    let state: TransportState
    
    init(group: Group, state: TransportState) {
        self.group = group
        self.state = state
    }
}

class SetTransportStateInteractor<T: SetTransportStateValues>: Interactor {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(requestValues: SetTransportStateValues?) -> Observable<Void> {
        
        guard let group = requestValues?.group,
              let state = requestValues?.state else {
                return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        switch state {
            case .playing:
                return self.renderingControlRepository.setPlay(group: group)
            case .paused:
                return self.renderingControlRepository.setPause(group: group)
            case .stopped:
                return self.renderingControlRepository.setStop(group: group)
            case .transitioning:
                return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
    }
}
