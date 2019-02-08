//
//  CompletableInteractor.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol CompletableInteractor: Interactor {
    
    func get() -> Completable
    
    mutating func get(values: T?) -> Completable
    
    func setup(values: T?) -> Completable
}

extension CompletableInteractor {
    
    func get() -> Completable {
        return Single.just(requestValues)
            .flatMapCompletable(setup)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    mutating func get(values: T?) -> Completable {
        self.requestValues = values
        return get()
    }
    
}
