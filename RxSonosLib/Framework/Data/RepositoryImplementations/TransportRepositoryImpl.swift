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
    
    private let network = LocalNetwork<TransportTarget>()
    
    func getNowPlaying(for room: Room) -> Single<Track?> {
        
        let positionInfoNetwork = network.request(.positionInfo, on: room)
        let mediaInfoNetwork = network.request(.mediaInfo, on: room)
        
        return Single.zip(positionInfoNetwork, mediaInfoNetwork, resultSelector: self.mapDataToNowPlaying(for: room))
    }
    
    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress> {
        return network.request(.positionInfo, on: room)
            .map(self.mapPositionInfoDataToProgress())
    }
    
    func getTransportState(for room: Room) -> Single<TransportState> {
        return network.request(.transportInfo, on: room)
            .map(mapTransportDataToState())
    }
    
    func getImage(for track: Track) -> Maybe<Data> {
        let downloadNetwork = DownloadNetwork()
        guard let imageUri = (track as? TrackImage)?.imageUri else {
            return Maybe.empty()
        }
            
        if let cachedImage = CacheManager.shared.get(for: .trackImage, item: track.uri) {
            return Maybe.just(cachedImage)
        }
        
        return downloadNetwork
            .request(download: imageUri)
            .do(onSuccess: { (data) in
                CacheManager.shared.set(data, for: .trackImage, item: track.uri)
            })
            .asMaybe()
    }
    
    func setNextTrack(for room: Room) -> Completable {
        return network.request(.next, on: room)
            .asCompletable()
    }
    
    func setPreviousTrack(for room: Room) -> Completable {
        return network.request(.previous, on: room)
            .asCompletable()
    }
    
    func setPlay(group: Group) -> Completable {
        return network.request(.play, on: group.master)
            .asCompletable()
    }
    
    func setPause(group: Group) -> Completable {
        return network.request(.pause, on: group.master)
            .asCompletable()
    }
    
    func setStop(group: Group) -> Completable {
        return network.request(.stop, on: group.master)
            .asCompletable()
    }
}

fileprivate extension TransportRepositoryImpl {
    fileprivate func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String]) throws -> Track?) {
        return { positionInfoResult, mediaInfoResult in
            guard let track = try NowPlayingTrackFactory(room: room.ip, positionInfo: positionInfoResult, mediaInfo: mediaInfoResult).create() else {
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
