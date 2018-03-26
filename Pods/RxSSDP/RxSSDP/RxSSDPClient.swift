//
//  RxSSDPClient.swift
//  Sample App
//
//  Created by Stefan Renne on 17/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import CocoaAsyncSocket

class RxSSDPClient: NSObject {
    
    let broadcastAddress: String
    let searchTarget: String
    let port: UInt16
    
    init(broadcastAddress: String, searchTarget: String, port: UInt16 = 1900) {
        self.broadcastAddress = broadcastAddress
        self.searchTarget = searchTarget
        self.port = port
    }
    
    func discover() -> Observable<SSDPResponse> {
        
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
        let delegate = RxGCDAsyncUdpSocketDelegateProxy(parentObject: socket)
        socket.setDelegate(delegate)
        
        return Observable<SSDPResponse>.create({ (observable) -> Disposable in
            
            var disposables = [Disposable]()
            let receiveResponseObserver = delegate
                .didReceiveResponsePublishSubject
                .asObserver()
                .subscribe(onNext: { (response) in
                    observable.onNext(response)
                }, onError: { (error) in
                    observable.onError(error)
                })
            disposables.append(receiveResponseObserver)
            
            let didCloseObserver = delegate
                .didClosePublishSubject
                .asObserver()
                .subscribe(onNext: {
                    observable.onCompleted()
                }, onError: { (error) in
                    observable.onError(error)
                    observable.onCompleted()
                })
            disposables.append(didCloseObserver)
            
            do {
                try socket.enableBroadcast(true)
                let message = SSDPRequest(searchTarget: self.searchTarget, broadcastAddress: self.broadcastAddress, port: self.port)
                socket.send(message.data, toHost: self.broadcastAddress, port: self.port, withTimeout: -1, tag: 0)
                try socket.beginReceiving()
            } catch {
                observable.onError(error)
            }
            
            
            return Disposables.create(disposables)
        })
        .observeOn(MainScheduler.asyncInstance)
    }
}

extension RxSSDPClient: GCDAsyncUdpSocketDelegate { }
