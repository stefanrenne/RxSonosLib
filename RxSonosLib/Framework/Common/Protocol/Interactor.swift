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
    associatedtype R: RequestValues
    associatedtype E
    
    func buildInteractorObservable(requestValues: R?) -> Observable<E>
    func get(values: R?) -> Observable<E>
}

extension Interactor {
    
    func createTimer(_ period: RxTimeInterval) -> Observable<Int> {
        return Observable<Int>.create({ (observer) -> Disposable in
            
            observer.onNext(0)
            
            let interval = Observable<Int>
                .interval(period, scheduler: MainScheduler.instance)
                .subscribe(observer)
            
            return Disposables.create([interval])
        })
    }
    
    func get(values: R? = nil) -> Observable<E> {
        return buildInteractorObservable(requestValues: values)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
