//
//  SetMuteInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class SetMuteValues: RequestValues {
    let room: Room
    let enabled: Bool
    
    init(room: Room, enabled: Bool) {
        self.room = room
        self.enabled = enabled
    }
}

class SetMuteInteractor<T: SetMuteValues>: Interactor {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(requestValues: SetMuteValues?) -> Observable<Void> {
        
        guard let room = requestValues?.room,
              let enabled = requestValues?.enabled else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return renderingControlRepository.setMute(room: room, enabled: enabled)
    }
}
