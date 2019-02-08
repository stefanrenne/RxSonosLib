//
//  ObservableInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol ObservableInteractor: Interactor {
    
    associatedtype U
    
    func get() -> Observable<U>
    
    mutating func get(values: T?) -> Observable<U>
    
    func setup(values: T?) -> Observable<U>
}

extension ObservableInteractor {
    
    func get() -> Observable<U> {
        return Observable.just(requestValues)
            .flatMap(setup)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    mutating func get(values: T?) -> Observable<U> {
        self.requestValues = values
        return get()
    }
    
}
