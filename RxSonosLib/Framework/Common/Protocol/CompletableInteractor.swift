//
//  CompletableInteractor.swift
//  Demo App
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol CompletableInteractor: Interactor {
    
    func get() -> Completable
    
    func get(values: T?) -> Completable
    
    func buildInteractorObservable(values: T?) -> Completable
}

extension CompletableInteractor {
    
    func get() -> Completable {
        return get(values: nil)
    }
    
    func get(values: T?) -> Completable {
        return buildInteractorObservable(values: values)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
}
