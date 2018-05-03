//
//  GetTrackImageInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetTrackImageValues: RequestValues {
    let track: Track
    
    init(track: Track) {
        self.track = track
    }
}

class GetTrackImageInteractor<T: GetTrackImageValues>: Interactor {
    
    let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(requestValues: GetTrackImageValues?) -> Observable<Data?> {
        
        guard let track = requestValues?.track else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return self.transportRepository
            .getImage(for: track)
    }
}
