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
    
}
