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
    
    func getVolume(for room: Room) -> Observable<Int> {
        return GetVolumeNetwork(room: room)
            .executeSoapRequest()
            .map(self.mapDataToVolume())
    }
    
    func getVolume(for group: Group) -> Observable<Int> {
        let roomObservables = ([group.master] + group.slaves).map(self.mapRoomToVolume())
        return Observable.zip(roomObservables, self.zipRoomVolumes())
    }
    
    func set(volume: Int, for room: Room) -> Observable<Void> {
        return SetVolumeNetwork(room: room, volume: volume)
            .executeSoapRequest()
            .toVoid()
    }
    
    func set(volume: Int, for group: Group) -> Observable<Void> {
        let roomObservables = ([group.master] + group.slaves).map({ set(volume: volume, for: $0) })
        return Observable.zip(roomObservables).toVoid()
    }
    
    func setPlay(group: Group) -> Observable<Void> {
        return SetPlayNetwork(room: group.master)
            .executeSoapRequest()
            .toVoid()
    }
    
    func setPause(group: Group) -> Observable<Void> {
        return SetPauseNetwork(room: group.master)
            .executeSoapRequest()
            .toVoid()
    }
    
    func setStop(group: Group) -> Observable<Void> {
        return SetStopNetwork(room: group.master)
            .executeSoapRequest()
            .toVoid()
    }
    
    func setMute(room: Room, enabled: Bool) -> Observable<Void> {
        return SetMuteNetwork(room: room, enabled: enabled)
            .executeSoapRequest()
            .toVoid()
    }
    
    func getMute(room: Room) -> Observable<Bool> {
        return GetMuteNetwork(room: room)
            .executeSoapRequest()
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
    
    fileprivate func mapRoomToVolume() -> ((Room) -> Observable<Int>) {
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
