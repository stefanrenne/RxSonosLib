//
//  String+Regex.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2016 Uberweb. All rights reserved.
//

import Foundation


extension String {
    
    func extractUUID() -> String? {
        return self.match(with: "uuid:([a-zA-Z0-9_]+)")?.resultForString(self, index: 1)
    }
    
    func baseUrl() -> String? {
        return self.match(with: "(https?://[0-9:.]+)")?.resultForString(self, index: 1)
    }
    
    func urlSuffix() -> String? {
        return self.match(with: "^https?://[0-9:.]+(.*)$")?.resultForString(self, index: 1)
    }
    
    
    func musicServiceFromUrl() -> MusicService {
        let service = self.match(with: "([a-zA-Z0-9-]+):")?.resultForString(self, index: 1)
        return MusicService.map(string: service)
    }
    
    func validateXml() -> String {
        let regex = try! NSRegularExpression(pattern: "(\")([A-Za-z0-9-:]+=)", options: [])
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
