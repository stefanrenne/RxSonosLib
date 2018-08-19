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
    
    private let trackMeta: [String: String]?
    private let currentURIMetaData: [String: String]?
    
    init(room: URL, positionInfo: [String: String], mediaInfo: [String: String]) {
        self.room = room
        self.positionInfo = positionInfo
        self.mediaInfo = mediaInfo
        self.trackMeta = positionInfo["TrackMetaData"]?.mapMetaItem()
        self.currentURIMetaData = mediaInfo["CurrentURIMetaData"]?.mapMetaItem()
    }
    
    func create() -> Track? {
        guard let (uri, type) = getMusicService() else { return nil }
        
        if type == .tv {
            return createTVTrack()
        }else  if type == .library {
            return createLibraryTrack(uri: uri)
        }else{
             return createTrack(uri: uri, type: type)
        }
    }
    
    private func createLibraryTrack(uri: String?) -> MusicProviderTrack? {
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = uri,
            let imageUri = URL(string: room.absoluteString + "/getaa?u=" + uri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!),
            let description = getDescription() else {
                return nil
        }
        
        return MusicProviderTrack(sid: 9998, flags: nil, sn: nil, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description)
    }
    
    private func createTrack(uri: String?, type: MusicService) -> MusicProviderTrack? {
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let sid = type.sid,
            let queueItem = Int(queueItemString),
            let uri = uri,
            let imageUri = URL(string: room.absoluteString + "/getaa?s=1&u=" + uri),
            let description = getDescription() else {
                return nil
        }
        
        return MusicProviderTrack(sid: sid, flags: type.flags, sn: type.sn, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description)
    }
    
    private func createTVTrack() -> TVTrack? {
        
        guard let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"] else {
                return nil
        }
        return TVTrack(queueItem: queueItem, uri: uri)
    }
    
    private func getMusicService() -> (url: String, service: MusicService)? {
        if let url = mediaInfo["CurrentURI"], let service = MusicService.map(url: url) {
            return (url, service)
        }
        
        if let url = positionInfo["TrackURI"], let service = MusicService.map(url: url) {
            return (url, service)
        }
        return nil
    }
    
    private func getDescription() -> [TrackDescription: String]? {
        guard let title = currentURIMetaData?["title"] ?? trackMeta?["title"] else { return nil }
        var description = [TrackDescription.title: title]
        
        if let artist = trackMeta?["creator"] {
            description[TrackDescription.artist] = artist
        }
        
        if let album = trackMeta?["album"] {
            description[TrackDescription.album] = album
        }
        
        if let information = trackMeta?["streamContent"]?.nilIfEmpty() {
            description[TrackDescription.information] = information
        }
        
        return description
    }
}
