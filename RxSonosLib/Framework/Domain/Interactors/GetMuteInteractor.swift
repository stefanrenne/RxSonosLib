//
//  GetMuteInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetMuteValues: RequestValues {
    let room: Room
    
    init(room: Room) {
        self.room = room
    }
}

class GetMuteInteractor: BaseInteractor<GetMuteValues, Bool> {
    
    let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    override func buildInteractorObservable(requestValues: GetMuteValues?) -> Observable<Bool> {
        
        guard let room = requestValues?.room else {
                return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return createTimer(SonosSettings.shared.renewRoomMuteTimer)
            .flatMap(self.mapToMute(for: room))
            .distinctUntilChanged()
    }
    
    fileprivate func mapToMute(for room: Room) -> ((Int) -> Observable<Bool>) {
        return { _ in
            return self.renderingControlRepository
                .getMute(room: room)
        }
    }
}
