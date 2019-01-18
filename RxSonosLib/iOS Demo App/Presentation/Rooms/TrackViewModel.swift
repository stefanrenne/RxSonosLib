//
//  TrackViewModel.swift
//  iOS Demo App
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
    
    lazy var trackTitle: String? = {
        return track.title
    }()
    
    lazy var image: Observable<UIImage?> = {
       return Observable
            .just(track)
            .getImage()
            .catchErrorJustReturn(nil)
            .map({ (data) -> UIImage? in
                guard let data = data, let image = UIImage(data: data) else { return nil }
                return image
            })
    }()
    
    lazy var trackArtists: String? = {
        return track.artist
    }()
    
    lazy var trackDescription: NSAttributedString = {
        return track.description(filterd: [TrackDescription.title])
            .joined(separator: "  ●  ", attrs: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8), NSAttributedString.Key.baselineOffset: 2])
    }()
    
    lazy var trackGroupDescription: NSAttributedString = {
        return track.description(filterd: [TrackDescription.album])
            .joined(separator: "  ●  ", attrs: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8), NSAttributedString.Key.baselineOffset: 2])
    }()
}

extension Array where Element == String {
    public func joined(separator: String, attrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        enumerated().forEach { (index, string) in
            mutableString.append(NSAttributedString(string: string))
            if index < self.count-1 {
                mutableString.append(NSAttributedString(string: separator, attributes: attrs))
            }
        }
        return NSAttributedString(attributedString: mutableString)
    }
}
