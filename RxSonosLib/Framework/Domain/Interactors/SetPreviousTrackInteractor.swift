//
//  SetPreviousTrackInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetPreviousTrackValues: RequestValues {
    let group: Group
}

class SetPreviousTrackInteractor: CompletableInteractor {
    
    var requestValues: SetPreviousTrackValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func setup(values: SetPreviousTrackValues?) -> Completable {
        
        guard let group = values?.group else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return transportRepository
            .setPreviousTrack(for: group.master)
    }
}
