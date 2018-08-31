//
//  ContentDirectoryRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class ContentDirectoryRepositoryImpl: ContentDirectoryRepository {
    
    func getQueue(for room: Room) -> Single<[MusicProviderTrack]> {
        return LocalNetwork(room: room, action: ContentDirectoryTarget.browse)
            .executeRequest()
            .map(self.mapDataToQueue(room: room))
    }
    
}

extension ContentDirectoryRepositoryImpl {
    fileprivate func mapDataToQueue(room: Room) -> (([String: String]) -> [MusicProviderTrack]) {
        return { data in
            return data["Result"]?
                .mapMetaItems()?
                .enumerated()
                .compactMap(self.mapQueueItemToTrack(room: room)) ?? []
        }
    }
    
    fileprivate func mapQueueItemToTrack(room: Room) -> ((Int, [String: String]) -> MusicProviderTrack?) {
        return { index, data in
            return QueueTrackFactory(room: room.ip, queueItem: index + 1, data: data).create()
        }
    }
    
}
