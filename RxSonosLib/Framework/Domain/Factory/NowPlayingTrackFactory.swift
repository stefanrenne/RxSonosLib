//
//  NowPlayingTrackFactory.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class NowPlayingTrackFactory {
    
    private let room: URL
    private let positionInfo: [String: String]
    private let mediaInfo: [String: String]
    private var type: MusicService = .unknown
    
    init(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) {
        self.room = room
        self.positionInfo = positionInfo
        self.mediaInfo = mediaInfo
        self.determineMusicService()
    }
    
    private func determineMusicService() {
        
        if let url1 = mediaInfo["CurrentURI"], MusicService.map(url: url1) != MusicService.unknown {
            self.type = MusicService.map(url: url1)
        }
        
        if let url2 = positionInfo["TrackURI"], MusicService.map(url: url2) != MusicService.unknown {
            self.type = MusicService.map(url: url2)
        }
    }
    
    func create() -> Track? {
        //TODO: Refactor
        
        if self.type.sid == 9 {
            return createSpotifyTrack()
        }
        
        if self.type.sid == 254 {
            return createTuneinTrack()
        }
        
        if self.type == .tv {
            return createTVTrack()
        }
        
        return nil
    }
    
    private func createSpotifyTrack() -> SpotifyTrack? {
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
    
    private func createTuneinTrack() -> TuneinTrack? {
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
    
    private func createTVTrack() -> TVTrack? {
        
        guard let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"] else {
                return nil
        }
        return TVTrack(queueItem: queueItem, uri: uri)
    }
}
