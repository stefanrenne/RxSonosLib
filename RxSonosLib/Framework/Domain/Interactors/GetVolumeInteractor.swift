//
//  GetVolumeInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetVolumeValues: RequestValues {
    let group: Group
}

class GetVolumeInteractor: ObservableInteractor {
    
    var requestValues: GetVolumeValues?
    
    private let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(values: GetVolumeValues?) -> Observable<Int> {
        
        guard let group = requestValues?.group else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(self.mapToVolume(for: group))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToVolume(for group: Group) -> ((Int) -> Observable<Int>) {
        return { _ in
            return self.renderingControlRepository
                .getVolume(for: group)
                .asObservable()
        }
    }
}
