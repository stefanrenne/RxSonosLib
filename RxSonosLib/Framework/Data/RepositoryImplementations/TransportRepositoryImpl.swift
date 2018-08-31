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
    
    func getNowPlaying(for room: Room) -> Single<Track?> {
        
        let positionInfoNetwork = LocalNetwork(room: room, action: .positionInfo).executeRequest()
        let mediaInfoNetwork = LocalNetwork(room: room, action: .mediaInfo).executeRequest()
        
        return Single.zip(positionInfoNetwork, mediaInfoNetwork, resultSelector: self.mapDataToNowPlaying(for: room))
    }
    
    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress> {
        return LocalNetwork(room: room, action: .positionInfo)
            .executeRequest()
            .map(self.mapPositionInfoDataToProgress())
    }
    
    func getTransportState(for room: Room) -> Single<TransportState> {
        return LocalNetwork(room: room, action: .transportInfo)
            .executeRequest()
            .map(mapTransportDataToState())
    }
    
    func getImage(for track: Track) -> Maybe<Data> {
        guard let imageUri = (track as? TrackImage)?.imageUri else {
            return Maybe.empty()
        }
            
        if let cachedImage = CacheManager.shared.get(for: track.uri) {
            return Maybe.just(cachedImage)
        }
        
        return DownloadNetwork(location: imageUri)
            .executeRequest()
            .do(onSuccess: { (data) in
                CacheManager.shared.set(data, for: track.uri)
            })
            .asMaybe()
    }
    
    func setNextTrack(for room: Room) -> Completable {
        return LocalNetwork(room: room, action: .next)
            .executeRequest()
            .asCompletable()
    }
    
    func setPreviousTrack(for room: Room) -> Completable {
        return LocalNetwork(room: room, action: .previous)
            .executeRequest()
            .asCompletable()
    }
}

fileprivate extension TransportRepositoryImpl {
    fileprivate func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String]) throws -> Track?) {
        return { positionInfoResult, mediaInfoResult in
            guard let track = NowPlayingTrackFactory(room: room.ip, positionInfo: positionInfoResult, mediaInfo: mediaInfoResult).create() else {
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
