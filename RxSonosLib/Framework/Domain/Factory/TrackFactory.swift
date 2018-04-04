//
//  TrackFactory.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

struct TrackFactory {
    
    static func create(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        switch positionInfo["TrackURI"]?.musicServiceFromUrl() {
            case .some(.spotify):
                return TrackFactory.createSpotifyTrack(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            case .some(.tunein):
                return TrackFactory.createTuneinTrack(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            case .some(.tv):
                return TrackFactory.createTVTrack(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            default:
                return nil
        }
    }
    
    fileprivate static func createSpotifyTrack(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> SpotifyTrack? {
        let trackMeta = positionInfo["TrackMetaData"]?.mapMetaItem()
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"],
            let title = trackMeta?["title"],
            let artist = trackMeta?["creator"],
            let album = trackMeta?["album"],
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + uri) else {
                return nil
        }
        
        return SpotifyTrack(queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, title: title, artist: artist, album: album)
    }
    
    fileprivate static func createTuneinTrack(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> TuneinTrack? {
        let trackMeta = positionInfo["TrackMetaData"]?.mapMetaItem()
        let currentURIMetaData = mediaInfo["CurrentURIMetaData"]?.mapMetaItem()
        let information = trackMeta?["streamContent"]?.nilIfEmpty()
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"],
            let streamUri = mediaInfo["CurrentURI"],
            let title = currentURIMetaData?["title"],
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + streamUri) else {
                return nil
        }
        
        return TuneinTrack(queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, title: title, information: information)
    }
    
    fileprivate static func createTVTrack(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> TVTrack? {
        
        guard let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"] else {
                return nil
        }
        return TVTrack(queueItem: queueItem, uri: uri)
    }
}
