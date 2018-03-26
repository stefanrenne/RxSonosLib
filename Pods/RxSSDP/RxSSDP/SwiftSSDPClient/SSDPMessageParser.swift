//
//  SSDPResponseParser.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

class SSDPMessageParser {
  fileprivate let scanner: Scanner
  
  init(message: String) {
    scanner = Scanner(string: message)
    scanner.charactersToBeSkipped = CharacterSet.newlines
  }
  
  func parse() -> SSDPMessage? {
    guard let firstLine = scanLine(), let firstWord = firstLine.components(separatedBy: " ").first else {
      return nil
    }
    
    var keyBuffer: NSString? = nil
    var valueBuffer: String? = nil
    
    var messageDictionary = SSDPRequestDictionary()
    let parseDictionary = {
      while self.scanner.scanUpTo(":", into: &keyBuffer) {
        self.advancePastColon()
        
        let unicodeScalars = self.scanner.string.unicodeScalars
        let index = unicodeScalars.index(unicodeScalars.startIndex, offsetBy: self.scanner.scanLocation)
        
        if CharacterSet.newlines.contains(unicodeScalars[index]) {
          valueBuffer = ""
        } else {
          valueBuffer = self.scanLine()
        }
        
        if let keyBuffer = keyBuffer as String?, let valueBuffer = valueBuffer {
          messageDictionary[keyBuffer] = valueBuffer
        }
      }
    }
    
    if let method = SSDPRequestMethod(rawValue: firstWord) {
      parseDictionary()
      
      return SSDPRequest(method: method, dictionary: messageDictionary)
    } else if firstWord == "HTTP/1.1" {
      parseDictionary()
      
      return SSDPResponse(dictionary: messageDictionary)
    } else {
      print("INVALID SSDP MESSAGE")
    }
    
    return nil
  }
  
  fileprivate func scanLine() -> String? {
    var buffer: NSString? = nil
    scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &buffer)
    
    return (buffer as String?)
  }
  
  fileprivate func advancePastColon() {
    var string: NSString? = nil
    
    let characterSet = CharacterSet(charactersIn: ": ")
    scanner.scanCharacters(from: characterSet, into: &string)
  }
}

public protocol SSDPMessage {
  var searchTarget: String? { get }
}
