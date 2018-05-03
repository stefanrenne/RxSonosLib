//
//  SonosSettings.swift
//  Demo App
//
//  Created by Stefan Renne on 11/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

/**
 * In `SonosSettings` all general settings are saved, make sure to change these values before the first call on `SonosInteractor` is performed.
 */
open class SonosSettings {
    
    /**
     * singleton variable to access all RxSonosLib settings
     */
    public static let shared = SonosSettings()
    
    /**
     * The number of seconds to wait before the new set of network rooms is retrieved using SSDP
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewNetworkDevicesTimer: RxTimeInterval = 30
    
    /**
     * The maximum ammount of seconds to wait for network devices to respond to an m-search.
     * A higher value could lead to more waitin time when starting your app.
     * A lower value could lead into sonos devices not being discoverd.
     */
    public var searchNetworkForDevices: RxTimeInterval = 4
    
    /**
     * The number of seconds to wait before the new set of grouped rooms is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewGroupsTimer: RxTimeInterval = 4
    
    /**
     * The number of seconds to wait before the new active track is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewNowPlayingTimer: RxTimeInterval = 4
    
    /**
     * The number of seconds to wait before the new transport is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewGroupTransportStateTimer: RxTimeInterval = 2
    
    /**
     * The number of seconds to wait before the new track progress call is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewGroupTrackProgressTimer: RxTimeInterval = 1
    
    /**
     * The number of seconds to wait before the new group's track progress is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewGroupQueueTimer: RxTimeInterval = 2
    
    /**
     * The number of seconds to wait before the new group's volume is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewGroupVolumeTimer: RxTimeInterval = 1
    
    /**
     * The number of seconds to wait before the new mute state is retrieved
     * The result will only be onNext'd on the Observer if it is different from the previous result
     */
    public var renewRoomMuteTimer: RxTimeInterval = 2
    
}
