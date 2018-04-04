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
        return Array(track.description().values)
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
