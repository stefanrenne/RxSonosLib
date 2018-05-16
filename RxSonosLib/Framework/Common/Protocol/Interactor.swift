//
//  Interactor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/09/2017.
//  Copyright © 2017 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class RequestValues { }

protocol Interactor {
    associatedtype T: RequestValues
    associatedtype U
    
    func buildInteractorObservable(requestValues: T?) -> Observable<U>
    func get(values: T?) -> Observable<U>
}

extension Interactor {
    
    func get(values: T? = nil) -> Observable<U> {
        return buildInteractorObservable(requestValues: values)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    func createTimer(_ period: RxTimeInterval) -> Observable<Int> {
        return Observable<Int>.create({ (observer) -> Disposable in
            
            observer.onNext(0)
            
            let interval = Observable<Int>
                .interval(period, scheduler: MainScheduler.instance)
                .subscribe(observer)
            
            return Disposables.create([interval])
        })
    }
}
