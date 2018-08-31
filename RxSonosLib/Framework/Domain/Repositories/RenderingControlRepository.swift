//
//  RenderingControlRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol RenderingControlRepository {
    
    func getVolume(for room: Room) -> Single<Int>
    
    func getVolume(for group: Group) -> Single<Int>
    
    func set(volume: Int, for room: Room) -> Completable
    
    func set(volume: Int, for group: Group) -> Completable
    
    func setMute(room: Room, enabled: Bool) -> Completable
    
    func getMute(room: Room) -> Single<Bool>
    
}
