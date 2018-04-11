//
//  GetNowPlayingInteractor.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetNowPlayingValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetNowPlayingInteractor: BaseInteractor<GetNowPlayingValues, Track?>  {
    
    let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    override func buildInteractorObservable(requestValues: GetNowPlayingValues?) -> Observable<Track?> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(4)
            .flatMap(self.mapToTrack(for: masterRoom))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToTrack(for masterRoom: Room) -> (() -> Observable<Track?>) {
        return {
            return self.transportRepository
                .getNowPlaying(for: masterRoom)
        }
    }
}

