//
//  SSDPRequest.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

typealias SSDPRequestDictionary = [String: String]

enum SSDPRequestMethod: String {
  case Notify = "NOTIFY"
  case Search = "M-SEARCH"
}

public class SSDPRequest {
  let method: SSDPRequestMethod
  fileprivate let requestDictionary: [String: String]
  
  var data: Data {
    return requestString.data(using: String.Encoding.utf8)!
  }
  
  fileprivate var requestString: String {
    let requestString = requestDictionary.reduce("\(method.rawValue) * HTTP/1.1\r\n") { (accumulator, parameter) -> String in
      return accumulator + "\(parameter.0): \(parameter.1)\r\n"
    }
    
    return requestString+"\r\n"
  }
  
  convenience init(searchTarget: String) {
    let dictionary = [
      "HOST": "239.255.255.250:1900",
      "MAN": "\"ssdp:discover\"",
      "MX": "3",
      "ST": searchTarget,
      "USER-AGENT": "iOS/9.3"
    ]
    
    self.init(method: .Search, dictionary: dictionary)
  }
  
  init(method: SSDPRequestMethod, dictionary: SSDPRequestDictionary) {
    self.method = method
    self.requestDictionary = dictionary
  }
}

extension SSDPRequest: SSDPMessage {
  public var searchTarget: String? {
    return requestDictionary["ST"]
  }
}

extension SSDPRequest: CustomStringConvertible {
  public var description: String {
    return requestString
  }
}
