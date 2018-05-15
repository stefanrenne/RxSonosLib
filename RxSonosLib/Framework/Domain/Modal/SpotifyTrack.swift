//
//  SpotifyTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SpotifyTrack: Track, TrackImage {
    
    /**
     * track artist
     */
    public let artist: String
    
    /**
     * track album
     */
    public let album: String
    
    /**
     * image url
     * can be downloaded with:
     *      SonosInteractor.provideTrackImageInteractor()
     *      .get(values: GetTrackImageValues(track: Track))
     */
    internal let imageUri: URL
    
    /**
     * collection of all Tracks description items
     */
    override func description() -> [TrackDescription: String] {
        var description = super.description()
        description[TrackDescription.artist] = self.artist
        description[TrackDescription.album] = self.album
        return description
    }
    
    internal init(queueItem: Int, duration: UInt = 0, uri: String, imageUri: URL, title: String, artist: String, album: String) {
        self.artist = artist
        self.album = album
        self.imageUri = imageUri
        let service = MusicService.musicProvider(sid: 9, flags: nil, sn: nil) //TODO: update
        super.init(service: service, queueItem: queueItem, duration: duration, uri: uri, title: title)
    }
    
}
