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
        
        let positionInfoNetwork = GetPositionInfoNetwork(room: room).executeSoapRequest()
        let mediaInfoNetwork = GetMediaInfoNetwork(room: room).executeSoapRequest()
        
        return Observable.zip(positionInfoNetwork, mediaInfoNetwork, resultSelector: self.mapDataToNowPlaying(for: room))
    }
    
    func getTransportState(for room: Room) -> Observable<TransportState> {
        return GetTransportInfoNetwork(room: room)
            .executeSoapRequest()
            .map(mapTransportDataToState())
    }
    
}

fileprivate extension TransportRepositoryImpl {
    fileprivate func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String]) throws -> Track) {
        return { positionInfoResult, mediaInfoResult in
            guard let track = Track.map(room: room.ip, positionInfo: positionInfoResult, mediaInfo: mediaInfoResult) else {
                    #if DEBUG
                        print(positionInfoResult)
                    #endif
                    throw NSError.sonosLibNoDataError()
            }
            
            return track
        }
    }
    
    fileprivate func mapTransportDataToState() -> (([String: String]) -> TransportState) {
        return { data in
            return TransportState.map(string: data["CurrentTransportState"])
        }
    }
}
