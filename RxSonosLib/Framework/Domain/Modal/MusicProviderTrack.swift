//
//  MusicProviderTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

open class MusicProviderTrack: Track, TrackImage {
    
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
     * the id of the music provider
     */
    public let providerId: Int
    
    /**
     * I'm not sure yet what this value is
     */
    public let flags: Int?
    
    /**
     * I'm not sure yet what this value is
     */
    public let sn: Int?
    
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
    public let description: [TrackDescription: String]
    
    init(sid: Int, flags: Int?, sn: Int?, queueItem: Int, duration: UInt, uri: String, imageUri: URL, description: [TrackDescription: String]) {
        self.providerId = sid
        self.flags = flags
        self.sn = sn
        self.queueItem = queueItem
        self.duration = duration
        self.uri = uri
        self.imageUri = imageUri
        self.description = description
    }
    
}

extension MusicProviderTrack: Equatable {
    public static func == (lhs: MusicProviderTrack, rhs: MusicProviderTrack) -> Bool {
        return lhs.uri == rhs.uri
    }
}
