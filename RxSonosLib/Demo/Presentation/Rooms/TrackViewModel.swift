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
    
    lazy var trackAlbum: String? = {
        return track.album
    }()
    
    lazy var trackDescription: NSAttributedString = {
        return track.description(filterd: [TrackDescription.title])
            .joined(separator: "  ●  ", attrs: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 8), NSAttributedStringKey.baselineOffset: 2])
    }()
    
    lazy var trackGroupDescription: NSAttributedString = {
        return track.description(filterd: [TrackDescription.album])
            .joined(separator: "  ●  ", attrs: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 8), NSAttributedStringKey.baselineOffset: 2])
    }()
}


extension Array where Element == String {
    public func joined(separator: String, attrs: [NSAttributedStringKey: Any]) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        self.enumerated().forEach { (index, string) in
            mutableString.append(NSAttributedString(string: string))
            if index < self.count-1 {
                mutableString.append(NSAttributedString(string: separator, attributes: attrs))
            }
        }
        return NSAttributedString(attributedString: mutableString)
    }
}
