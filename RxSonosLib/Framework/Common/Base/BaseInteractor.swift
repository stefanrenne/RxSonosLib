//
//  BaseInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/09/2017.
//  Copyright © 2017 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

public protocol Interactor {
    associatedtype T: RequestValues
    associatedtype U
    
    func get(values: T?) -> Observable<U>
}

open class RequestValues {
    
}

open class BaseInteractor<T: RequestValues, U>: Interactor {
    
    func buildInteractorObservable(requestValues: T?) -> Observable<U> {
        fatalError("Override in subclass")
    }
    
    public func get(values: T? = nil) -> Observable<U> {
        return buildInteractorObservable(requestValues: values)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
    }
    
    internal func createTimer(_ period: RxTimeInterval) -> Observable<Int> {
        return Observable<Int>.create({ (observer) -> Disposable in
            
            observer.onNext(0)
            
            let interval = Observable<Int>
                .interval(period, scheduler: MainScheduler.instance)
                .subscribe(observer)
            
            return Disposables.create([interval])
        })
    }
    
    internal func addTimer<T>(_ period: RxTimeInterval) -> (([T]) throws -> Observable<[T]>) {
        return { object in
            return self.createTimer(period).map({ _ in return object })
        }
    }
    
}
