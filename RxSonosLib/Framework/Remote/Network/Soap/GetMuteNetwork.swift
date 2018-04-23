//
//  GetMuteNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class GetMuteNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .getMute)
    }
    
}
