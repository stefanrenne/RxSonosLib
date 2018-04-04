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
 * Options for a tracks description
 */
public enum TrackDescription: String {
    case title = "TITLE"
    case artist = "ARTIST"
    case album = "ALBUM"
    case information = "INFORMATION"
}

/**
 * Some `Track`'s have an image, these tracks response to the `TrackImage` protocol
 */
internal protocol TrackImage {
    
    /**
     * image url (optional)
     * can be downloaded with:
     *      SonosInteractor.provideTrackImageInteractor()
     *      .get(values: GetTrackImageValues(track: Track))
     */
    var imageUri: URL { get }
}

/**
 * Every item in the queue is a `Track`
 */
open class Track {
    
    /**
     * Type of track, example: spotify, tunein, tv
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
     * collection of all Tracks description items
     */
    public func description() -> [TrackDescription: String] {
        return [TrackDescription.title: self.title]
    }
    
    init(service: MusicService, queueItem: Int, duration: UInt, uri: String, title: String) {
        self.service = service
        self.queueItem = queueItem
        self.duration = duration
        self.uri = uri
        self.title = title
    }
    
}

extension Track: Equatable {
    public static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.uri == rhs.uri
    }
}
