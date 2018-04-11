//
//  TransportRepositoryImpl.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class TransportRepositoryImpl: TransportRepository {
    
    func getNowPlaying(for room: Room) -> Observable<Track?> {
        
        let positionInfoNetwork = GetPositionInfoNetwork(room: room).executeSoapRequest()
        let mediaInfoNetwork = GetMediaInfoNetwork(room: room).executeSoapRequest()
        
        return Observable.zip(positionInfoNetwork, mediaInfoNetwork, resultSelector: self.mapDataToNowPlaying(for: room))
    }
    
    func getNowPlayingProgress(for room: Room) -> Observable<GroupProgress> {
        return GetPositionInfoNetwork(room: room)
            .executeSoapRequest()
            .map(self.mapPositionInfoDataToProgress())
    }
    
    func getTransportState(for room: Room) -> Observable<TransportState> {
        return GetTransportInfoNetwork(room: room)
            .executeSoapRequest()
            .map(mapTransportDataToState())
    }
    
    func getImage(for track: Track) -> Observable<Data?> {
        guard let imageUri = (track as? TrackImage)?.imageUri else { return Observable<Data?>.just(nil) }
        return DownloadNetwork(location: imageUri, cacheKey: track.uri)
            .executeRequest()
            .map({ $0 })
    }
}

fileprivate extension TransportRepositoryImpl {
    fileprivate func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String]) throws -> Track?) {
        return { positionInfoResult, mediaInfoResult in
            guard let track = NowPlayingTrackFactory.create(room: room.ip, positionInfo: positionInfoResult, mediaInfo: mediaInfoResult) else {
                    return nil
            }
            
            return track
        }
    }
    
    fileprivate func mapTransportDataToState() -> (([String: String]) -> TransportState) {
        return { data in
            return TransportState.map(string: data["CurrentTransportState"])
        }
    }
    
    fileprivate func mapPositionInfoDataToProgress() -> (([String: String]) -> GroupProgress) {
        return { data in
            return GroupProgress.map(positionInfo: data)
        }
    }
}
