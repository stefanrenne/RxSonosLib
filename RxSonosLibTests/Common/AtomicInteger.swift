//
//  AtomicInteger.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 08/02/2019.
//  Copyright © 2019 Uberweb. All rights reserved.
//

import Foundation

final class AtomicInteger {
    
    let lock = DispatchSemaphore(value: 1)
    var _value: Int
    
    init(value initialValue: Int = 0) {
        _value = initialValue
    }
    
    convenience init() {
        self.init(value: 0)
    }
    
    var value: Int {
        get {
            lock.wait()
            defer { lock.signal() }
            return _value
        }
        set {
            lock.wait()
            defer { lock.signal() }
            _value = newValue
        }
    }
    
    @discardableResult
    func decrement() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value -= 1
        return _value
    }
    
    @discardableResult
    func increment() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value += 1
        return _value
    }
    
    func reset() {
        lock.wait()
        defer { lock.signal() }
        _value = 0
    }
}
