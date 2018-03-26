//
//  SSDPResponse.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 8/1/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

public typealias SSDPResponseDictionary = [String: String]

public class SSDPResponse {
  public let responseDictionary: [String: String]
  
  var data: Data {
    return responseString.data(using: String.Encoding.utf8)!
  }
  
  fileprivate var responseString: String {
    return responseDictionary.reduce("HTTP/1.1 200 OK\r\n", {
      return $0 + "\($1.0): \($1.1)\r\n"
    })+"\r\n"
  }
  
  init(dictionary: SSDPResponseDictionary) {
    self.responseDictionary = dictionary
  }
}

extension SSDPResponse: SSDPMessage {
  public var searchTarget: String? {
    return responseDictionary["ST"]
  }
}

extension SSDPResponse: CustomStringConvertible {
  public var description: String {
    return responseString
  }
}
