//
//  RxGCDAsyncUdpSocketDelegateProxy.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CocoaAsyncSocket

class RxGCDAsyncUdpSocketDelegateProxy: DelegateProxy<GCDAsyncUdpSocket, GCDAsyncUdpSocketDelegate>, DelegateProxyType, GCDAsyncUdpSocketDelegate {
    
    
    internal init(parentObject: GCDAsyncUdpSocket) {
        super.init(parentObject: parentObject, delegateProxy: RxGCDAsyncUdpSocketDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxGCDAsyncUdpSocketDelegateProxy(parentObject: $0) }
    }
    
    static func currentDelegate(for object: GCDAsyncUdpSocket) -> GCDAsyncUdpSocketDelegate? {
        return object.delegate()
    }
    
    static func setCurrentDelegate(_ delegate: GCDAsyncUdpSocketDelegate?, to object: GCDAsyncUdpSocket) {
        object.setDelegate(delegate)
    }
    
    lazy var didConnectPublishSubject = PublishSubject<Data>()
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        self.forwardToDelegate()?.udpSocket?(sock, didConnectToAddress: address)
        didConnectPublishSubject.onNext(address)
    }
    
    lazy var didNotConnectPublishSubject = PublishSubject<Void>()
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        self.forwardToDelegate()?.udpSocket?(sock, didNotConnect: error)
        if let error = error {
            didNotConnectPublishSubject.onError(error)
        } else {
            didNotConnectPublishSubject.onNext(())
        }
    }
    
    lazy var didNotSendDataWithTagPublishSubject = PublishSubject<Int>()
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        self.forwardToDelegate()?.udpSocket?(sock, didNotSendDataWithTag: tag, dueToError: error)
        if let error = error {
            didNotSendDataWithTagPublishSubject.onError(error)
        } else {
            didNotSendDataWithTagPublishSubject.onNext(tag)
        }
    }
    
    lazy var didSendDataWithTagPublishSubject = PublishSubject<Int>()
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        self.forwardToDelegate()?.udpSocket?(sock, didSendDataWithTag: tag)
        didSendDataWithTagPublishSubject.onNext(tag)
    }
    
    lazy var didClosePublishSubject = PublishSubject<Void>()
    internal func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        self.forwardToDelegate()?.udpSocketDidClose?(sock, withError: error)
        if let error = error {
            didClosePublishSubject.onError(error)
        } else {
            didClosePublishSubject.onNext(())
        }
    }
    
    lazy var didReceiveResponsePublishSubject = PublishSubject<SSDPResponse>()
    lazy var didReceiveRequestPublishSubject = PublishSubject<SSDPRequest>()
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        guard let messageString = String(data: data, encoding: .utf8),
            let message = SSDPMessageParser(message: messageString).parse() else { return }
        
        if let response = message as? SSDPResponse {
            didReceiveResponsePublishSubject.onNext(response)
        } else if let request = message as? SSDPRequest {
            didReceiveRequestPublishSubject.onNext(request)
        }
        
        self.forwardToDelegate()?.udpSocket?(sock, didReceive: data, fromAddress: address, withFilterContext: filterContext)
    }
    
    deinit {
        didConnectPublishSubject.onCompleted()
        didNotConnectPublishSubject.onCompleted()
        didNotSendDataWithTagPublishSubject.onCompleted()
        didSendDataWithTagPublishSubject.onCompleted()
        didClosePublishSubject.onCompleted()
        didReceiveResponsePublishSubject.onCompleted()
        didReceiveRequestPublishSubject.onCompleted()
    }
}
