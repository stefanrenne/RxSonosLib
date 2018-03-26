//
//  String+Regex.swift
//  Sonos Demo App
//
//  Created by info@stefanrenne.nl on 17/11/16.
//  Copyright © 2016 Stefan Renne. All rights reserved.
//

import Foundation


extension String {
    
    func extractUUID() -> String? {
        let pattern = "uuid:([a-zA-Z0-9_]+)"
        let matches = self.match(with: pattern)
        
        return matches?.resultForString(self, index: 1)
    }
    
    func baseUrl() -> String? {
        let pattern = "(https?://[0-9:.]+)"
        let matches = self.match(with: pattern)
        
        return matches?.resultForString(self, index: 1)
    }
    
    func urlSuffix() -> String? {
        let pattern = "^https?://[0-9:.]+(.*)$"
        let matches = self.match(with: pattern)
        
        return matches?.resultForString(self, index: 1)
    }
    
    func validateXml() -> String {
        let regex = try! NSRegularExpression(pattern: "(\")([A-Za-z0-9-]+=)", options: [])
        return regex.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count), withTemplate: "$1 $2")
    }
    
    func match(with pattern: String) -> NSTextCheckingResult? {
        return matches(with: pattern).first
    }
    
    func matches(with pattern: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
    }
}

extension NSTextCheckingResult {
    func resultForString(_ string: String, index: Int) -> String? {
        guard index < self.numberOfRanges,
            let swiftRange = self.range(at: index).toRange(for: string) else {
            return nil
        }
        return String(string[swiftRange])
    }
}

extension NSRange {
    func toRange(for str: String) -> Range<String.Index>? {
        guard let fromUTFIndex = str.index(str.startIndex, offsetBy: location, limitedBy: str.endIndex),
            let toUTFIndex = str.index(fromUTFIndex, offsetBy: length, limitedBy: str.endIndex),
            let fromIndex = String.Index(fromUTFIndex, within: str),
            let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        return fromIndex ..< toIndex
    }
}
