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


class GetVolumeInteractor<T: GetVolumeValues>: Interactor {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(requestValues: GetVolumeValues?) -> Observable<Int> {
        
        guard let group = requestValues?.group else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(self.mapToVolume(for: group))
            .distinctUntilChanged({ $0 == $1 })
    }
    
    fileprivate func mapToVolume(for group: Group) -> ((Int) -> Observable<Int>) {
        return { _ in
            return self.renderingControlRepository
                .getVolume(for: group)
        }
    }
}
