//
//  GetGroupProgressInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetGroupProgressValues: RequestValues {
    let group: Group
}

class GetGroupProgressInteractor: ObservableInteractor {
    
    var requestValues: GetGroupProgressValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: GetGroupProgressValues?) -> Observable<GroupProgress> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupTrackProgressTimer)
            .flatMap(self.mapToProgress(for: masterRoom))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToProgress(for masterRoom: Room) -> ((Int) -> Observable<GroupProgress>) {
        return { _ in
            return self.transportRepository
                .getNowPlayingProgress(for: masterRoom)
                .asObservable()
        }
    }
}
