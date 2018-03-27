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
                description += " | " + album
            }
        }
        return description
    }()
    
    lazy var image: Observable<UIImage?> = {
        guard let url = track.imageUri else { return Observable.just(nil) }
        
        return Observable<UIImage?>.create({ (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    observer.onNext(image)
                    observer.onCompleted()
                } else if let error = error {
                    observer.onError(error)
                }
            })
            task.resume()
            
            return Disposables.create()
        })
    }()
}
