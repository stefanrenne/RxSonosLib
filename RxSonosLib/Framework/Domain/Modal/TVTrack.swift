//
//  TVTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class TVTrack: Track {
    
    internal init(queueItem: Int, uri: String) {
        super.init(queueItem: queueItem, duration: 0, uri: uri, title: "TV")
    }
    
}
