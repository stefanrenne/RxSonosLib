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
    
    func getQueue(for room: Room) -> Observable<[Track]> {
        return GetQueueNetwork(room: room)
            .executeSoapRequest()
            .map(self.mapDataToQueue(room: room))
    }
    
}

extension ContentDirectoryRepositoryImpl {
    fileprivate func mapDataToQueue(room: Room) -> (([String: String]) -> [Track]) {
        return { data in
            return data["Result"]?
                .mapMetaItems()?
                .enumerated()
                .compactMap(self.mapQueueItemToTrack(room: room)) ?? []
        }
    }
    
    fileprivate func mapQueueItemToTrack(room: Room) -> ((Int, [String: String]) -> Track?) {
        return { index, data in
            return QueueTrackFactory.create(room: room.ip, queueItem: index + 1, data: data)
        }
    }
    
}
