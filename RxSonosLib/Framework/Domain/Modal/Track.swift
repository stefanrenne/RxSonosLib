//
//  Track.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift


/**
 * Every item in the queue is a `Track`
 */
open class Track {
    
    /**
     * Type of track, example: Spotify, TuneIn, TV
     */
    public let service: MusicService
    
    /**
     * Number item in the queue
     */
    public let queueItem: Int
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    public let duration: UInt
    
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
     * can be downloaded with:
     *      SonosInteractor.provideTrackImageInteractor()
     *      .get(values: GetTrackImageValues(track: Track))
     */
    internal let imageUri: URL?
    
    internal init(service: MusicService, queueItem: Int, duration: UInt = 0, uri: String, imageUri: URL? = nil, title: String, artist: String? = nil, album: String? = nil) {
        self.service = service
        self.queueItem = queueItem
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
        return lhs.uri == rhs.uri
    }
}

extension Track {
    class func map(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        
        switch (positionInfo["TrackURI"]?.musicServiceFromUrl()) {
            case .some(.spotify):
                return Track.mapSpotify(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            case .some(.tunein):
                return Track.mapTunein(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            case .some(.tv):
                return Track.mapTV(room: room, positionInfo: positionInfo, mediaInfo: mediaInfo)
            default: break
        }
        return nil
    }
    
    class func mapSpotify(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> Track? {
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
        
        return Track(service: .spotify, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, title: title, artist: artist, album: album)
    }
    
    class func mapTV(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        guard let queueItemString = positionInfo["Track"],
              let queueItem = Int(queueItemString),
              let uri = positionInfo["TrackURI"] else {
                return nil
        }
        
        return Track(service: .tv, queueItem: queueItem, uri: uri, title: "TV")
    }
    
    class func mapTunein(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) -> Track? {
        let currentURIMetaData = mediaInfo["CurrentURIMetaData"]?.mapMetaItem()
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
              let queueItemString = positionInfo["Track"],
              let queueItem = Int(queueItemString),
              let uri = positionInfo["TrackURI"],
              let streamUri = mediaInfo["CurrentURI"],
              let title = currentURIMetaData?["title"],
              let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + streamUri) else {
                return nil
        }
        
        return Track(service: .tunein, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, title: title)
    }
}
