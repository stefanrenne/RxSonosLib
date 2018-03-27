//
//  String+Time.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

extension String {
    func timeToSeconds() -> Int {
        let components = self.split(separator: ":")
        
        var seconds = Int(components[components.count-1]) ?? 0
        
        if components.count - 2 >= 0,
            let minutes = Int(components[components.count - 2]) {
            seconds += (minutes * 60)
        }
        
        if components.count - 3 >= 0,
            let hours = Int(components[components.count - 3]) {
            seconds += (hours * 60 * 60)
        }
        
        return seconds
    }
}
