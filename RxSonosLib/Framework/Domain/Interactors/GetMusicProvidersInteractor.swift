//
//  GetMusicProvidersInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct GetMusicProvidersValues: RequestValues {
    let room: Room?
}

class GetMusicProvidersInteractor: SingleInteractor {
    
    var requestValues: GetMusicProvidersValues?
    
    private let musicProvidersRepository: MusicProvidersRepository
    
    init(musicProvidersRepository: MusicProvidersRepository) {
        self.musicProvidersRepository = musicProvidersRepository
    }
    
    func buildInteractorObservable(values: GetMusicProvidersValues?) -> Single<[MusicProvider]> {
        guard let room = requestValues?.room else {
            return Single.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return musicProvidersRepository
            .getMusicProviders(for: room)
    }
    
}
