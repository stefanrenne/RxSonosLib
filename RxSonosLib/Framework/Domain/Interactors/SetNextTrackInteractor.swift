//
//  SetNextTrackInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetNextTrackValues: RequestValues {
    let group: Group
}

class SetNextTrackInteractor: CompletableInteractor {
    
    var requestValues: SetNextTrackValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: SetNextTrackValues?) -> Completable {
        guard let group = requestValues?.group else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return transportRepository
            .setNextTrack(for: group.master)
    }
}
