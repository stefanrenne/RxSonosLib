//
//  Interactor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/09/2017.
//  Copyright © 2017 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol RequestValues { }

protocol Interactor {
    
    associatedtype T: RequestValues
    var requestValues: T? { get set }
}
