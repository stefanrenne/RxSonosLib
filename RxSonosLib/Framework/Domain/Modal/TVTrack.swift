//
//  TVTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class TVTrack: Track {
    
    /**
     * Number item in the queue
     */
    public let queueItem: Int
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    public let duration: UInt = 0
    
    /**
     * track url
     */
    public var uri: String
    
    /**
     * collection of all Tracks description items
     */
    public var description = [TrackDescription: String]()
    
    internal init(queueItem: Int, uri: String) {
        self.queueItem = queueItem
        self.uri = uri
    }
    
}
