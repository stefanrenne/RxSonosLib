//
//  GetNowPlayingInteractor.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetNowPlayingValues: RequestValues {
    let group: Group
}

class GetNowPlayingInteractor: ObservableInteractor {
    
    var requestValues: GetNowPlayingValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: GetNowPlayingValues?) -> Observable<Track?> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewNowPlayingTimer)
            .flatMap(self.mapToTrack(for: masterRoom))
            .distinctUntilChanged({ lhs, rhs in
                guard let lhs = lhs, let rhs = rhs, lhs.uri == rhs.uri else { return false }
                return true
            })
    }
    
    private func mapToTrack(for masterRoom: Room) -> ((Int) -> Observable<Track?>) {
        return { _ in
            return self.transportRepository
                .getNowPlaying(for: masterRoom)
                .asObservable()
        }
    }
}
