//
//  RxCocoaAsyncSocket.swift
//  RxSonosLib
//
//  Created by Stefan Opinity on 20/10/2017.
//  Copyright © 2017 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CocoaAsyncSocket

enum SocketEvent {
    case connected
    case disconnected(Error?)
    case data(Data)
}

class RxCocoaAsyncSocketDelegateProxy: DelegateProxy {
    fileprivate let subject = PublishSubject<SocketEvent>()
    fileprivate weak var delegate: GCDAsyncSocketDelegate?
    
    required init(parentObject: AnyObject) {
        let socket = parentObject as? GCDAsyncSocket
        delegate = socket?.delegate
        super.init(parentObject: parentObject)
    }
    
    deinit {
        subject.onCompleted()
    }
}

extension RxCocoaAsyncSocketDelegateProxy: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        subject.onNext(.connected)
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
        subject.onNext(.data(data))
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        subject.onNext(.disconnected(err))
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
    }
}

extension RxCocoaAsyncSocketDelegateProxy: DelegateProxyType {
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        guard let socket = object as? GCDAsyncSocket else {
            return
        }
        socket.delegate = delegate as? GCDAsyncSocketDelegate
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let socket = object as? GCDAsyncSocket
        return socket?.delegate
    }
}

extension Reactive where Base : GCDAsyncSocket {
    var response: Observable<SocketEvent> {
        return RxCocoaAsyncSocketDelegateProxy.proxyForObject(base).subject
    }
    
    var connected: Observable<Bool> {
        return response.filter({
            event -> Bool in
            switch event {
            case .connected, .disconnected:
                return true
            default:
                return false
            }
        }).map({
            event in
            switch event {
            case .connected:
                return true
            default:
                return false
            }
        })
    }
    
    var json: Observable<[String: Any]?> {
        return response.filter({
            event -> Bool in
            switch event {
            case .data:
                return true
            default:
                return false
            }
        }).map({
            event in
            switch event {
            case .data(let data):
                return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
            default:
                return nil
            }
        })
    }
}
