//
//  GetMusicProvidersInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetMusicProvidersValues: RequestValues {
    let room: Room?
    
    init(room: Room?) {
        self.room = room
    }
}

class GetMusicProvidersInteractor<R: GetMusicProvidersValues>: Interactor {
    
    let musicProvidersRepository: MusicProvidersRepository
    
    init(musicProvidersRepository: MusicProvidersRepository) {
        self.musicProvidersRepository = musicProvidersRepository
    }
    
    func buildInteractorObservable(requestValues: GetMusicProvidersValues?) -> Observable<[MusicProvider]> {
        
        guard let room = requestValues?.room else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return musicProvidersRepository.getMusicProviders(for: room)
    }
    
}
