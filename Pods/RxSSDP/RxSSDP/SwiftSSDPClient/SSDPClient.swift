//
//  SSDPClient.swift
//  SSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

private let broadcastAddress = "239.255.255.250"

public class SSDPClient: NSObject {
  public weak var delegate: SSDPClientDelegate?
  
  fileprivate lazy var socket: GCDAsyncUdpSocket = { () -> GCDAsyncUdpSocket in
    let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
    
    do {
      try socket.enableBroadcast(true)
    } catch let error {
      print(error)
    }
    
    
    return socket
  }()
  
  public init(delegate: SSDPClientDelegate) {
    self.delegate = delegate
  }
  
  public func discoverAllDevices() {
    let message = SSDPRequest(searchTarget: "ssdp:all")
    
    socket.send(message.data, toHost: broadcastAddress, port: 1900, withTimeout: -1, tag: 0)
    beginReceiving()
  }
  
  public func discoverRootDevices() {
    let message = SSDPRequest(searchTarget: "upnp:rootdevice")
    
    socket.send(message.data, toHost: broadcastAddress, port: 1900, withTimeout: -1, tag: 0)
    beginReceiving()
  }
  
  public func discover(_ searchTarget: String) {
    let message = SSDPRequest(searchTarget: searchTarget)
    
    socket.send(message.data, toHost: "239.255.255.250", port: 1900, withTimeout: -1, tag: 0)
    
    beginReceiving()
  }
  
  private func beginReceiving() {
    do {
      try socket.beginReceiving()
    } catch let error {
      print(error)
    }
  }
  
  public func stopDiscovery() {
    socket.close()
  }
  
  deinit {
    stopDiscovery()
  }
}

extension SSDPClient: GCDAsyncUdpSocketDelegate {
  public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    guard let messageString = String(data: data as Data, encoding: String.Encoding.utf8) else {
      return
    }
    
    let parser = SSDPMessageParser(message: messageString)
    
    guard let message = parser.parse() else {
      print("Message not parsed")
      return
    }
    
    if let response = message as? SSDPResponse {
      delegate?.received(response)
    } else if let request = message as? SSDPRequest {
      delegate?.received(request)
    }
  }
}

public protocol SSDPClientDelegate: class {
  func received(_ request: SSDPRequest)
  func received(_ response: SSDPResponse)
}
