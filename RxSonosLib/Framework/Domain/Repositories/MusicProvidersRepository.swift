//
//  MusicProvidersRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol MusicProvidersRepository {
    
    func getMusicProviders(for room: Room) -> Single<[MusicProvider]>
    
}
