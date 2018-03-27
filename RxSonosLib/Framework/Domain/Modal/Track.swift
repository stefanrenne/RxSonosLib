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
     * Current track playing time in seconds, example: 90 for 0:01:30
     */
    public var time: Int
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    public let duration: Int
    
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
    
    internal init(service: MusicService, queueItem: Int, state: TransportState = .StoppedStream, time: Int = 0, duration: Int = 0, uri: String, imageUri: URL? = nil, title: String, artist: String? = nil, album: String? = nil) {
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

extension Track: Equatable {
    public static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.uri == rhs.uri && lhs.state == rhs.state
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
        
        guard let time = nowPlaying["RelTime"]?.timeToSeconds(),
            let duration = nowPlaying["TrackDuration"]?.timeToSeconds(),
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
