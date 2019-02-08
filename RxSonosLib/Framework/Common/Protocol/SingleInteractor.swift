//
//  SingleInteractor.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol SingleInteractor: Interactor {
    
    associatedtype U
    
    func get() -> Single<U>
    
    mutating func get(values: T?) -> Single<U>
    
    func setup(values: T?) -> Single<U>
}

extension SingleInteractor {
    
    func get() -> Single<U> {
        return Single.just(requestValues)
            .flatMap(setup)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    mutating func get(values: T?) -> Single<U> {
        self.requestValues = values
        return get()
    }
    
}
