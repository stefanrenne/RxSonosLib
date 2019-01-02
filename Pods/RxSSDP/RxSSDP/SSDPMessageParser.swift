//
//  SSDPMessageParser.swift
//  RxSSDP
//
//  Created by Stefan Renne on 18/06/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class SSDPMessageParser {
    fileprivate let scanner: Scanner
    
    init(message: String) {
        scanner = Scanner(string: message)
        scanner.charactersToBeSkipped = CharacterSet.newlines
    }
    
    func parse() -> SSDPResponse? {
        guard let firstLine = scanLine(),
            let firstWord = firstLine.components(separatedBy: " ").first,
            firstWord == "HTTP/1.1" else {
            return nil
        }
        
        var keyBuffer: NSString?
        var valueBuffer: String?
        
        var message = [String: String]()
        while self.scanner.scanUpTo(":", into: &keyBuffer) {
            self.advancePastColon()
            
            let unicodeScalars = self.scanner.string.unicodeScalars
            let index = unicodeScalars.index(unicodeScalars.startIndex, offsetBy: self.scanner.scanLocation)
            
            if unicodeScalars.count <= index.encodedOffset || CharacterSet.newlines.contains(unicodeScalars[index]) {
                valueBuffer = ""
            } else {
                valueBuffer = self.scanLine()
            }
            
            if let keyBuffer = keyBuffer as String?, let valueBuffer = valueBuffer, keyBuffer.count > 0 {
                message[keyBuffer] = valueBuffer
            }
        }
        
        return SSDPResponse(data: message)
    }
    
    fileprivate func scanLine() -> String? {
        var buffer: NSString?
        scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &buffer)
        
        return (buffer as String?)
    }
    
    fileprivate func advancePastColon() {
        var string: NSString?
        
        let characterSet = CharacterSet(charactersIn: ": ")
        scanner.scanCharacters(from: characterSet, into: &string)
    }
}
