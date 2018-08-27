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
    
    func getVolume(for room: Room) -> Single<Int> {
        return GetVolumeNetwork(room: room)
            .executeRequest()
            .map(self.mapDataToVolume())
    }
    
    func getVolume(for group: Group) -> Single<Int> {
        let roomObservables = ([group.master] + group.slaves).map(self.mapRoomToVolume())
        return Single.zip(roomObservables, self.zipRoomVolumes())
    }
    
    func set(volume: Int, for room: Room) -> Completable {
        return SetVolumeNetwork(room: room, volume: volume)
            .executeRequest()
            .asCompletable()
    }
    
    func set(volume: Int, for group: Group) -> Completable {
        let roomObservables = ([group.master] + group.slaves).map({ SetVolumeNetwork(room: $0, volume: volume).executeRequest() })
        return Single.zip(roomObservables).asCompletable()
    }
    
    func setPlay(group: Group) -> Completable {
        return SetPlayNetwork(room: group.master)
            .executeRequest()
            .asCompletable()
    }
    
    func setPause(group: Group) -> Completable {
        return SetPauseNetwork(room: group.master)
            .executeRequest()
            .asCompletable()
    }
    
    func setStop(group: Group) -> Completable {
        return SetStopNetwork(room: group.master)
            .executeRequest()
            .asCompletable()
    }
    
    func setMute(room: Room, enabled: Bool) -> Completable {
        return SetMuteNetwork(room: room, enabled: enabled)
            .executeRequest()
            .asCompletable()
    }
    
    func getMute(room: Room) -> Single<Bool> {
        return GetMuteNetwork(room: room)
            .executeRequest()
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
                    throw NSError.sonosLibNoDataError()
            }
            return (mute == 1)
        }
        
    }
}
