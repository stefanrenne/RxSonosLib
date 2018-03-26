//
//  AEXMLDocument+Create.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import AEXML

extension AEXMLDocument {
    class func create(_ data: Data) -> AEXMLDocument? {
        let string = String(data: data, encoding: .utf8)
        return AEXMLDocument.create(string)
    }
    
    class func create(_ string: String?) -> AEXMLDocument? {
        guard let cleanString = string?.removeXmlNamespace() else { return nil }
        return try? AEXMLDocument(xml: cleanString)
    }
}

fileprivate extension String {
    
    func removeXmlNamespace() -> String {
        var string = self.validateXml()
        if let regex1 = try? NSRegularExpression(pattern: "<([a-zA-Z]+:)", options:.caseInsensitive) {
            string = regex1.stringByReplacingMatches(in: string, options: [], range: NSRange(0..<string.count), withTemplate: "<")
        }
        if let regex2 = try? NSRegularExpression(pattern: "</([a-zA-Z]+:)", options:.caseInsensitive) {
            string = regex2.stringByReplacingMatches(in: string, options: [], range: NSRange(0..<string.count), withTemplate: "</")
        }
        return string
    }
    
}
