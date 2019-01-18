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

class GetMuteInteractor: ObservableInteractor {
    
    typealias T = GetMuteValues
    
    private let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(values: GetMuteValues?) -> Observable<Bool> {
        
        guard let room = values?.room else {
                return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewRoomMuteTimer)
            .flatMap(mapToMute(for: room))
            .distinctUntilChanged()
    }
}

private extension GetMuteInteractor {
    
    func mapToMute(for room: Room) -> ((Int) -> Observable<Bool>) {
        return { _ in
            return self.renderingControlRepository
                .getMute(room: room)
                .asObservable()
        }
    }
}
