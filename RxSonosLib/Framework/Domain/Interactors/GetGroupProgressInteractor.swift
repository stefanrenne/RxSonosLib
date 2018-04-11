//
//  GetGroupProgressInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetGroupProgressValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetGroupProgressInteractor: BaseInteractor<GetGroupProgressValues, GroupProgress> {
    
    let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    override func buildInteractorObservable(requestValues: GetGroupProgressValues?) -> Observable<GroupProgress> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(1)
            .flatMap(self.mapToProgress(for: masterRoom))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToProgress(for masterRoom: Room) -> (() -> Observable<GroupProgress>) {
        return {
            return self.transportRepository
                .getNowPlayingProgress(for: masterRoom)
        }
    }
}
