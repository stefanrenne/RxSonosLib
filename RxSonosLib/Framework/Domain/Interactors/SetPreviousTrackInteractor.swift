//
//  SetPreviousTrackInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class SetPreviousTrackValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class SetPreviousTrackInteractor: Interactor {
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(requestValues: SetPreviousTrackValues?) -> Observable<Never> {
        
        guard let group = requestValues?.group else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return transportRepository
            .setPreviousTrack(for: group.master)
            .asObservable()
    }
}
