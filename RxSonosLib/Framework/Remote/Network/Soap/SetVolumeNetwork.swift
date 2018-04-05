//
//  SetVolumeNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 05/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SetVolumeNetwork: SoapNetwork {
    
    init(room: Room, volume: Int) {
        super.init(room: room, action: .setVolume(volume))
    }
    
}
