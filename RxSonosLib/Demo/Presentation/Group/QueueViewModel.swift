//
//  QueueViewModel.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxSonosLib

class QueueViewModel {
    fileprivate let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    lazy var description: String = {
        var description = track.description()
        description.removeValue(forKey: TrackDescription.album)
        return Array(description.values)
            .joined(separator: "\n")
    }()
    
    lazy var image: Observable<UIImage?> = {
        return SonosInteractor.provideTrackImageInteractor()
            .get(values: GetTrackImageValues(track: self.track))
            .map({ (data) -> UIImage? in
                guard let data = data else { return nil }
                return UIImage(data: data)
            })
    }()
}
