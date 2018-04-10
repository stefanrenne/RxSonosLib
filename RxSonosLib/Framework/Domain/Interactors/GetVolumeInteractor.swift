//
//  GetVolumeInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetVolumeValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetVolumeInteractor: BaseInteractor<GetVolumeValues, Int> {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    override func buildInteractorObservable(requestValues: GetVolumeValues?) -> Observable<Int> {
        
        guard let group = requestValues?.group else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(1)
            .flatMap(self.mapToVolume(for: group))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToVolume(for group: Group) -> (() -> Observable<Int>) {
        return {
            return self.renderingControlRepository
                .getVolume(for: group)
        }
    }
}
