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
    
    func getNowPlaying(for room: Room) -> Observable<Track> {
        
        let nowPlayingNetwork = GetNowPlayingNetwork(room: room).executeSoapRequest()
        let tansportInfoNetwork = GetTransportInfoNetwork(room: room).executeSoapRequest()
        let mediaInfoNetwork = GetMediaInfoNetwork(room: room).executeSoapRequest()
        
        return Observable.zip(nowPlayingNetwork, tansportInfoNetwork, mediaInfoNetwork, resultSelector: self.mapDataToNowPlaying(for: room))
    }
    
}

fileprivate extension TransportRepositoryImpl {
    fileprivate func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String], [String: String]) throws -> Track) {
        return { nowPlayingResult, transportInfoResult, mediaInfoResult in
            guard let track = Track.map(room: room.ip, nowPlaying: nowPlayingResult, transportInfo: transportInfoResult, mediaInfo: mediaInfoResult) else {
                    #if DEBUG
                        print(nowPlayingResult)
                    #endif
                    throw NSError.sonosLibNoDataError()
            }
            
            return track
        }
    }
}
