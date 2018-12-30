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

class GetMusicProvidersInteractor: SingleInteractor {
    
    typealias T = GetMusicProvidersValues
    
    private let musicProvidersRepository: MusicProvidersRepository
    
    init(musicProvidersRepository: MusicProvidersRepository) {
        self.musicProvidersRepository = musicProvidersRepository
    }
    
    func buildInteractorObservable(values: GetMusicProvidersValues?) -> Single<[MusicProvider]> {
        guard let room = values?.room else {
            return Single.error(SonosError.invalidImplementation)
        }
        
        return musicProvidersRepository
            .getMusicProviders(for: room)
    }
    
}
