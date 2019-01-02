//
//  SSDPRepository.swift
//  RxSSDP
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol SSDPRepository {
    
    func scan(searchTarget: String) -> Single<[SSDPResponse]>
    
}
