//
//  TrackViewModel.swift
//  Demo App
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxSonosLib

class TrackViewModel {
    private let track: Track
    init(track: Track) {
        self.track = track
    }
    
    lazy var description: String = {
        var description = track.title
        if let artist = track.artist {
            description += "\n" + artist
            if let album = track.album {
                description += "\n" + album
            }
        }
        return description
    }()
    
    lazy var image: Observable<UIImage?> = {
        return SonosInteractor.provideTrackImageInteractor()
            .get(values: GetTrackImageValues(track: self.track))
    }()
}
