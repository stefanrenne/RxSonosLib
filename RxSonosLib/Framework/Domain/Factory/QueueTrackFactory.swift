//
//  QueueTrackFactory.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

struct QueueTrackFactory {
    
    static func create(room: URL, queueItem: Int, data: [String: String]) -> Track? {
        
        switch data["res"]?.musicServiceFromUrl() {
        case .some(.spotify):
            return QueueTrackFactory.createSpotifyTrack(room: room, queueItem: queueItem, data: data)
        default:
            return nil
        }
    }
    
    fileprivate static func createSpotifyTrack(room: URL, queueItem: Int, data: [String: String]) -> SpotifyTrack? {
        
        guard let duration = data["resduration"]?.timeToSeconds(),
            let uri = data["res"],
            let title = data["title"],
            let artist = data["creator"],
            let album = data["album"],
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + uri) else {
                return nil
        }
        
        return SpotifyTrack(queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, title: title, artist: artist, album: album)
    }
    
}
