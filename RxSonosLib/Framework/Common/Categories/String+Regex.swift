//
//  String+Regex.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2016 Uberweb. All rights reserved.
//

import Foundation

extension String {
    
    func extractUUID() throws -> String? {
        return try match(with: "uuid:([a-zA-Z0-9_]+)")?.first
    }
    
    func baseUrl() throws -> String? {
        return try match(with: "(https?://[0-9:.]+)")?.first
    }
    
    func urlSuffix() throws -> String? {
        return try match(with: "^https?://[0-9:.]+(.*)$")?.first
    }
    
    func validateXml() throws -> String {
        let regex = try NSRegularExpression(pattern: "(\")([A-Za-z0-9-:]+=)", options: [])
        return regex.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: count), withTemplate: "$1 $2")
    }
    
    func match(with pattern: String) throws -> [String]? {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: count)).first?.toArray(for: self)
    }
    
    var int: Int? {
        return Int(self)
    }
}

extension Array where Element == URLQueryItem {
    subscript(key: String) -> String? {
        return filter({ $0.name == key }).first?.value
    }
}

extension NSTextCheckingResult {
    func toArray(for string: String) -> [String] {
        var result = [String]()
        for index in 1..<numberOfRanges {
            if let value = substring(for: string, index: index) {
                result.append(value)
            }
        }
        return result
    }
    
    func substring(for string: String, index: Int) -> String? {
        guard index < numberOfRanges,
            let swiftRange = range(at: index).toRange(for: string) else {
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
