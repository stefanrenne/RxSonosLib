//
//  GetTransportStateInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 28/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetTransportStateValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetTransportStateInteractor: ObservableInteractor {
    
    typealias T = GetTransportStateValues
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: GetTransportStateValues?) -> Observable<TransportState> {
        
        guard let masterRoom = values?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupTransportStateTimer)
            .flatMap(mapToTransportState(for: masterRoom))
            .distinctUntilChanged({ $0.rawValue == $1.rawValue })
    }
}

private extension GetTransportStateInteractor {
    
    func mapToTransportState(for masterRoom: Room) -> ((Int) -> Observable<TransportState>) {
        return { _ in
            return self.transportRepository
                .getTransportState(for: masterRoom)
                .asObservable()
        }
    }
}
