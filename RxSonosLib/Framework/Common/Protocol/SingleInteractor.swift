//
//  SingleInteractor.swift
//  Demo App
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol SingleInteractor: Interactor {
    
    associatedtype U
    
    func get() -> Single<U>
    
    func get(values: T?) -> Single<U>
    
    func buildInteractorObservable(values: T?) -> Single<U>
}

extension SingleInteractor {
    
    func get() -> Single<U> {
        return get(values: nil)
    }
    
    func get(values: T?) -> Single<U> {
        return buildInteractorObservable(values: requestValues)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
}
