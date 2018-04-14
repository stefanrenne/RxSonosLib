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
    
    func getVolume(for room: Room) -> Observable<Int> {
        return Observable.just(30)
    }
    
    func getVolume(for group: Group) -> Observable<Int> {
        return Observable.just(70)
    }
    
    func set(volume: Int, for room: Room) -> Observable<Void> {
        return Observable.just(())
    }
    
    var lastVolume: Int?
    func set(volume: Int, for group: Group) -> Observable<Void> {
        self.lastVolume = volume
        return Observable.just(())
    }
    
    var activeState: TransportState?
    func setPlay(group: Group) -> Observable<Void> {
        activeState = TransportState.playing
        return Observable.just(())
    }
    
    func setPause(group: Group) -> Observable<Void> {
        activeState = TransportState.paused
        return Observable.just(())
    }
    
    func setStop(group: Group) -> Observable<Void> {
        activeState = TransportState.stopped
        return Observable.just(())
    }
    
}
