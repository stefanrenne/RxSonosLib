//
//  CacheManager.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    fileprivate var documentPath: URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        return URL(fileURLWithPath: path)
    }
    
    fileprivate func urlForKey(_ key: String) -> URL? {
        return self.documentPath?.appendingPathComponent(key.cleanKey)
    }
    
    func set(_ data: Data, for key: String?) {
        guard let key = key,
            let url = self.urlForKey(key) else { return }
        try? data.write(to: url)
    }
    
    func get(for key: String?) -> Data? {
        guard let key = key,
            let url = self.urlForKey(key),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func deleteAll() {
        guard let documentPath = documentPath,
            let result = try? FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil) else { return }
        
        result.forEach { (url) in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
}

fileprivate extension String {
    var cleanKey: String {
        return self.removing(characters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890-").inverted)
    }
    
    private func removing(characters: CharacterSet) -> String {
        let components = self.components(separatedBy: characters)
        return components.joined(separator: "")
    }
}
