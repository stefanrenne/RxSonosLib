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

class GetTrackImageInteractor: ObservableInteractor {
    
    var requestValues: GetTrackImageValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func setup(values: GetTrackImageValues?) -> Observable<Data?> {
        
        guard let track = values?.track else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return Observable<Data?>.create({ (observable) -> Disposable in
            return self.transportRepository
                .getImage(for: track)
                .subscribe(onSuccess: { (data) in
                    observable.onNext(data)
                    observable.onCompleted()
                }, onError: { (error) in
                    observable.onError(error)
                }, onCompleted: {
                    observable.onNext(nil)
                    observable.onCompleted()
                })
        })
        
    }
}
