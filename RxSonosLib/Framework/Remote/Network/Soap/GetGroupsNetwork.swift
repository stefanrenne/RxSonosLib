//
//  GetGroupsNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetGroupsNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .State)
    }
    
    
}
