//
//  GetNowPlayingNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetNowPlayingNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .nowPlaying)
    }
    
}
