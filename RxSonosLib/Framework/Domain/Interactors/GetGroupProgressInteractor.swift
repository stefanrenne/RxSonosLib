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

class GetGroupProgressInteractor: ObservableInteractor {
    
    var requestValues: GetGroupProgressValues?
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func setup(values: GetGroupProgressValues?) -> Observable<GroupProgress> {
        
        guard let masterRoom = values?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupTrackProgressTimer)
            .flatMap(mapToProgress(for: masterRoom))
            .distinctUntilChanged({ $0 == $1 })
    }
}

private extension GetGroupProgressInteractor {
    
    func mapToProgress(for masterRoom: Room) -> ((Int) -> Observable<GroupProgress>) {
        return { _ in
            return self.transportRepository
                .getNowPlayingProgress(for: masterRoom)
                .asObservable()
        }
    }
}
