//
//  Track.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation


/**
 * Every item in the queue is a `Track`
 */
open class Track {
    
    /**
     * Type of track, example: Spotify, TuneIn, TV
     */
    public let service: MusicService
    
    /**
     * State of the current track
     */
    public var state: TransportState
    
    /**
     * Number item in the queue
     */
    public let queueItem: Int
    
    /**
     * Current track playing time, example: 0:01:30
     */
    public var time: String
    
    /**
     * Track duration time, example: 0:04:24
     */
    public let duration: String
    
    /**
     * track url
     */
    public let uri: String
    
    /**
     * track title
     */
    public let title: String
    
    /**
     * track artist (optional)
     */
    public let artist: String?
    
    /**
     * track album (optional)
     */
    public let album: String?
    
    /**
     * image url (optional)
     */
    public let imageUri: URL?
    
    internal init(service: MusicService, queueItem: Int, state: TransportState = .StoppedStream, time: String = "0:00:00", duration: String = "0:00:00", uri: String, imageUri: URL? = nil, title: String, artist: String? = nil, album: String? = nil) {
        self.service = service
        self.queueItem = queueItem
        self.state = state
        self.time = time
        self.duration = duration
        self.uri = uri
        self.imageUri = imageUri
        self.title = title
        self.artist = artist
        self.album = album
    }
    
}

extension Track {
    class func map(room: URL, nowPlaying: [String: String], transportInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        
        switch (nowPlaying["TrackURI"]?.musicServiceFromUrl()) {
            case .some(.Spotify):
                return Track.mapSpotify(room: room, nowPlaying: nowPlaying, transportInfo: transportInfo, mediaInfo: mediaInfo)
            default: break
        }
        return nil
    }
    
    class func mapSpotify(room: URL, nowPlaying: [String: String], transportInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        let trackMeta = nowPlaying["TrackMetaData"]?.mapMetaItem()
        let state = TransportState.map(string: transportInfo["CurrentTransportState"], for: .Spotify)
        
        guard let time = nowPlaying["RelTime"],
            let duration = nowPlaying["TrackDuration"],
            let queueItemString = nowPlaying["Track"],
            let queueItem = Int(queueItemString),
            let uri = nowPlaying["TrackURI"],
            let title = trackMeta?["title"],
            let artist = trackMeta?["creator"],
            let album = trackMeta?["album"],
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + uri) else {
                return nil
        }
        
        return Track(service: .Spotify, queueItem: queueItem, state: state, time: time, duration: duration, uri: uri, imageUri: imageUri, title: title, artist: artist, album: album)
        
    }
}
