//
//  Alarm.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation

public enum PlayMode: String {
    case shuffle = "SHUFFLE"
}

public enum Recurrence: String {
    case once = "ONCE"
}

public struct Alarm {
    let id: Int
    let enabled: Bool
    let startTime: String
    let duration: String
    let recurrence: Recurrence
    let programURI: String
    let playMode: PlayMode
    let includeLinkedZones: Bool
    let roomUUID: String
    let metaData: [String: String]?
    let volume: Int
}
