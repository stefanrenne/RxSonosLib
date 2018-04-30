//
//  MusicServicesRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class MusicServicesRepositoryImpl: MusicServicesRepository {
    
    func getMusicServices() -> Observable<[MusicService]> {
        return Observable.just([])
    }
    
}
