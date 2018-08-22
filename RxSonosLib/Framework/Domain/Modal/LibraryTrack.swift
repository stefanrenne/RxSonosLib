//
//  LibraryTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 22/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

open class LibraryTrack: Track, TrackImage {
    
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
    
    init(queueItem: Int, duration: UInt, uri: String, imageUri: URL, description: [TrackDescription: String]) {
        self.queueItem = queueItem
        self.duration = duration
        self.uri = uri
        self.imageUri = imageUri
        self.description = description
    }
    
}
