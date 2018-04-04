//
//  ContentDirectoryRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol ContentDirectoryRepository {
    
    func getQueue(for room: Room) -> Observable<[Track]>
    
}
