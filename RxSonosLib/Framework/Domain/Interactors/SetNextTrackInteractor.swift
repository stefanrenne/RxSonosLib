//
//  SetNextTrackInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class SetNextTrackValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class SetNextTrackInteractor<T: SetNextTrackValues>: Interactor {
    
    let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(requestValues: SetNextTrackValues?) -> Observable<Void> {
        
        guard let group = requestValues?.group else {
                return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return transportRepository.setNextTrack(for: group.master)
    }
}
