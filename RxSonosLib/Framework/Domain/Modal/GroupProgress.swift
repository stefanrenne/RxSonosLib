//
//  Progress.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

/**
 * Every now playing track has a `GroupProgress`
 */
open class GroupProgress {
    
    /**
     * Current track playing time in seconds, example: 90 for 0:01:30
     */
    public var time: UInt
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    public let duration: UInt
    
    /**
     * Current group progress example: 0.5 for time 30 seconds and duration of 60 seconds
     */
    public lazy var progress: Float = {
        guard time > 0 else { return 0.0 }
        let value = Float(time) / Float(duration)
        return Float(String(format: "%.2f", value))!
    }()
    
    /**
     * Current track playing time in string, example: 1:30 for 90 seconds
     */
    public lazy var timeString: String = {
        return self.time.toTimeString()
    }()
    
    /**
     * Current track duration time in string, example: 4:24 for 264 seconds
     */
    public lazy var durationString: String = {
        return self.duration.toTimeString()
    }()
    
    /**
     * Current track remaining time in string, example: -2:24 for 144 remaining seconds
     */
    public lazy var remainingTimeString: String = {
        let remainingTime = self.duration - self.time
        guard remainingTime > 0 else { return "0:00" }
        return "-" + remainingTime.toTimeString()
    }()
    
    init(time: UInt, duration: UInt) {
        self.time = [time, duration].min()!
        self.duration = duration
    }
}

extension GroupProgress: Equatable {
    public static func == (lhs: GroupProgress, rhs: GroupProgress) -> Bool {
        return lhs.time == rhs.time && lhs.duration == rhs.duration
    }
}

extension GroupProgress {
    class func map(positionInfo: [String: String]) -> GroupProgress {
        guard let time = positionInfo["RelTime"]?.timeToSeconds(),
              let duration = positionInfo["TrackDuration"]?.timeToSeconds() else {
                return GroupProgress(time: 0, duration: 0)
        }
        return GroupProgress(time: time, duration: duration)
    }
}

fileprivate extension UInt {
    func toTimeString() -> String {
        var totalSeconds = self
        let totalHours = totalSeconds / (60 * 60)
        totalSeconds -= totalHours * 60 * 60
        let totalMinutes = totalSeconds / 60
        totalSeconds -= totalMinutes * 60
        
        if totalHours > 0 {
            return "\(totalHours):" + String(format: "%02d", totalMinutes) + ":" + String(format: "%02d", totalSeconds)
        } else {
            return "\(totalMinutes):" + String(format: "%02d", totalSeconds)
        }
    }
}
