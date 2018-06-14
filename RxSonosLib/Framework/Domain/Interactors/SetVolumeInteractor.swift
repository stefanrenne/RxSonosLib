//
//  SetVolumeInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class SetVolumeValues: RequestValues {
    let group: Group
    let volume: Int
    
    init(group: Group, volume: Int) {
        self.group = group
        self.volume = volume
    }
}

class SetVolumeInteractor<T: SetVolumeValues>: Interactor {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(requestValues: SetVolumeValues?) -> Observable<Void> {
        
        guard let group = requestValues?.group,
              let volume = requestValues?.volume else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return self.renderingControlRepository.set(volume: volume, for: group)
    }
}
