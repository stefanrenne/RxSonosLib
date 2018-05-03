//
//  GetMusicServicesInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetMusicServicesValues: RequestValues {
    let room: Room?
    
    init(room: Room?) {
        self.room = room
    }
}

class GetMusicServicesInteractor<T: GetMusicServicesValues>: Interactor {
    
    let musicServicesRepository: MusicServicesRepository
    
    init(musicServicesRepository: MusicServicesRepository) {
        self.musicServicesRepository = musicServicesRepository
    }
    
    func buildInteractorObservable(requestValues: GetMusicServicesValues?) -> Observable<[MusicService]> {
        
        guard let room = requestValues?.room else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return musicServicesRepository.getMusicServices(for: room)
    }
    
}
