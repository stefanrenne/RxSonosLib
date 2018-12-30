//
//  RenderingControlRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class RenderingControlRepositoryImpl: RenderingControlRepository {
    
    private let network = LocalNetwork<RenderingControlTarget>()
    
    func getVolume(for room: Room) -> Single<Int> {
        return network
            .request(.getVolume, on: room)
            .map(self.mapDataToVolume())
    }
    
    func getVolume(for group: Group) -> Single<Int> {
        let roomObservables = ([group.master] + group.slaves).map(self.mapRoomToVolume())
        return Single.zip(roomObservables, self.zipRoomVolumes())
    }
    
    func set(volume: Int, for room: Room) -> Completable {
        return network
            .request(.setVolume(volume), on: room)
            .asCompletable()
    }
    
    func set(volume: Int, for group: Group) -> Completable {
        let roomObservables = ([group.master] + group.slaves).map({ network.request(.setVolume(volume), on: $0) })
        return Single.zip(roomObservables).asCompletable()
    }
    
    func setMute(room: Room, enabled: Bool) -> Completable {
        return network
            .request(.setMute(enabled), on: room)
            .asCompletable()
    }
    
    func getMute(room: Room) -> Single<Bool> {
        return network
            .request(.getMute, on: room)
            .map(self.mapDataToMute())
    }
    
}

extension RenderingControlRepositoryImpl {
    fileprivate func mapDataToVolume() -> (([String: String]) -> Int) {
        return { data in
            guard let volumeString = data["CurrentVolume"],
                  let volume = Int(volumeString) else {
                return 0
            }
            return volume
        }
    }
    
    fileprivate func mapRoomToVolume() -> ((Room) -> Single<Int>) {
        return { room in
            return self.getVolume(for: room)
        }
    }
    
    fileprivate func zipRoomVolumes() -> (([Int]) -> Int) {
        return { volumes in
            return volumes.reduce(0, +) / volumes.count
        }
    }
    
    fileprivate func mapDataToMute() -> (([String: String]) throws -> Bool) {
        return { data in
            guard let muteString = data["CurrentMute"],
                  let mute = Int(muteString) else {
                    throw SonosError.noData
            }
            return (mute == 1)
        }
        
    }
}
