//
//  CacheManager.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

enum CacheKey: String {
    case ssdpCacheKey
}

class CacheManager {
    
    static let shared = CacheManager()
    
    fileprivate var documentPath: URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    fileprivate func urlForKey(_ key: String) -> URL? {
        return self.documentPath?.appendingPathComponent(key.cleanKey)
    }
    
    func set(_ data: Data?, for key: String?) {
        guard let key = key,
            let url = self.urlForKey(key) else { return }
        
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func set<T>(object: T, for key: String?) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        set(data, for: key)
    }
    
    func get(for key: String?) -> Data? {
        guard let key = key,
            let url = self.urlForKey(key),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func getObject<T>(for key: String?) -> T? {
        guard let data: Data = get(for: key),
            let object: T = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else { return nil }
        return object
    }
    
    func deleteAll() {
        let exclude = self.longCache()
        guard let documentPath = documentPath,
            let result = try? FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil) else { return }
        
        result.forEach { (url) in
            if !exclude.contains(url.lastPathComponent) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
    
    func longCache() -> [String] {
        return [CacheKey.ssdpCacheKey.rawValue]
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
