//
//  SetMuteInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetMuteValues: RequestValues {
    let room: Room
    let enabled: Bool
}

class SetMuteInteractor: CompletableInteractor {
    
    var requestValues: SetMuteValues?
    
    private let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func setup(values: SetMuteValues?) -> Completable {
        
        guard let room = values?.room,
              let enabled = values?.enabled else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return renderingControlRepository
            .setMute(room: room, enabled: enabled)
    }
}
