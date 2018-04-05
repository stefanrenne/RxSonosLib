//
//  RenderingControlRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol RenderingControlRepository {
    
    func getVolume(for room: Room) -> Observable<Int>
    
    func getVolume(for group: Group) -> Observable<Int>
    
    func set(volume: Int, for room: Room) -> Observable<Void>
    
    func set(volume: Int, for group: Group) -> Observable<Void>
    
}
