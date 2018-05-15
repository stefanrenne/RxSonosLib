//
//  TuneinTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class TuneinTrack: Track, TrackImage {
    
    /**
     * track information
     */
    public let information: String?
    
    /**
     * image url (optional)
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
        if let information = self.information {
            description[TrackDescription.information] = information
        }
        return description
    }
    
    internal init(queueItem: Int, duration: UInt = 0, uri: String, imageUri: URL, title: String, information: String? = nil) {
        self.information = information
        self.imageUri = imageUri
        let service = MusicService.musicProvider(sid: 254, flags: nil, sn: nil) //TODO: update
        super.init(service: service, queueItem: queueItem, duration: duration, uri: uri, title: title)
    }
}
