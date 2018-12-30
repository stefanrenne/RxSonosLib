//
//  Rx+Timer.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 30/12/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

func createTimer(_ period: RxTimeInterval) -> Observable<Int> {
    return Observable<Int>.create({ (observer) -> Disposable in
        
        observer.onNext(0)
        
        let interval = Observable<Int>
            .interval(period, scheduler: MainScheduler.instance)
            .subscribe(observer)
        
        return Disposables.create([interval])
    })
}
