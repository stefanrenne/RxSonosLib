//
//  FakeRenderingControlRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxSonosLib

class FakeRenderingControlRepositoryImpl: RenderingControlRepository {
    
    func getVolume(for room: Room) -> Single<Int> {
        return Single.just(30)
    }
    
    func getVolume(for group: Group) -> Single<Int> {
        return Single.just(70)
    }
    
    func set(volume: Int, for room: Room) -> Completable {
        return Completable.empty()
    }
    
    var lastVolume: Int?
    func set(volume: Int, for group: Group) -> Completable {
        self.lastVolume = volume
        return Completable.empty()
    }
    
    let numberSetMuteCalls = AtomicInteger()
    func setMute(room: Room, enabled: Bool) -> Completable {
        numberSetMuteCalls.increment()
        return Completable.empty()
    }
    
    let numberGetMuteCalls = AtomicInteger()
    func getMute(room: Room) -> Single<Bool> {
        numberGetMuteCalls.increment()
        return Single.just(true)
    }
}
