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
    
    func get(values: T?) -> Observable<U>
    
    func buildInteractorObservable(values: T?) -> Observable<U>
}

extension ObservableInteractor {
    
    func get() -> Observable<U> {
        return get(values: nil)
    }
    
    func get(values: T?) -> Observable<U> {
        return buildInteractorObservable(values: values)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
    }
    
}
