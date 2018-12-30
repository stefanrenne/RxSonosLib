//
//  Rx+Helpers.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 20/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

func ignoreNil<T>() -> ((T?) -> Observable<T>) {
    return { object in
        return object.map(Observable.just) ?? Observable.empty()
    }
}
