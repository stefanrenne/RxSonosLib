//
//  SetVolumeInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetVolumeValues: RequestValues {
    let group: Group
    let volume: Int
}

class SetVolumeInteractor: CompletableInteractor {
    
    var requestValues: SetVolumeValues?
    
    private let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func setup(values: SetVolumeValues?) -> Completable {
        guard let group = values?.group,
              let volume = values?.volume else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return renderingControlRepository
            .set(volume: volume, for: group)
    }
}
