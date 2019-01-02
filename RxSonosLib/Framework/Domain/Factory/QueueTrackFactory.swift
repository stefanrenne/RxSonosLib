//
//  QueueTrackFactory.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

struct QueueTrackFactory {
    
    private let room: URL
    private let queueItem: Int
    private let data: [String: String]
    
    init(room: URL, queueItem: Int, data: [String: String]) {
        self.room = room
        self.queueItem = queueItem
        self.data = data
    }
    
    func create() throws -> MusicProviderTrack? {
        
        guard let duration = data["resduration"]?.timeToSeconds(),
            let uri = data["res"],
            let service = try MusicService.map(url: uri),
            let sid = service.sid,
            let description = getDescription(),
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + uri) else {
                return nil
        }
        
        return MusicProviderTrack(sid: sid, flags: service.flags, sn: service.sn, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description)
    }
    
    private func getDescription() -> [TrackDescription: String]? {
        guard let title = data["title"] else { return nil }
        var description = [TrackDescription.title: title]
        
        if let artist = data["creator"] {
            description[TrackDescription.artist] = artist
        }
        if let album = data["album"] {
            description[TrackDescription.album] = album
        }
        
        return description
    }
    
}
