//
//  RoomRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol RoomRepository {
    
    func getRoom(device: SSDPDevice) -> Observable<Room>?
    
}

