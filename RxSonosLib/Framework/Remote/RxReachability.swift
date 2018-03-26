//
//  RxReachability.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import Reachability

class RxReachability {
    
    static let shared =  RxReachability()
    let status: Variable<Reachability.Connection>
    
    static var hasInternet: Bool { return RxReachability.shared.status.value.available }
    static var hasWifiInternet: Bool { return RxReachability.shared.status.value == .wifi }
    
    fileprivate let reachability = Reachability()!
    init() {
        self.status = Variable(self.reachability.connection)
        self.reachability.whenReachable = self.reachabilityChanged()
        self.reachability.whenUnreachable = self.reachabilityChanged()
        self.startNotifications()
    }
    
    deinit {
        self.stopNotifications()
    }
    
    fileprivate func startNotifications() {
        self.status.value = self.reachability.connection
        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    fileprivate func stopNotifications() {
        self.reachability.stopNotifier()
    }
    
    fileprivate func reachabilityChanged() -> Reachability.NetworkUnreachable {
        return { [weak self] (reachability) in
            self?.status.value = reachability.connection
        }
    }
}

extension Reachability.Connection {
    var available: Bool {
        switch self {
        case .cellular, .wifi:
            return true
        default:
            return false
        }
    }
}
