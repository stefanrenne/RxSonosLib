//
//  CacheManager.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

enum CacheKey: String, CaseIterable {
    case ssdp
    case room
    case trackImage
    
    var isLongCache: Bool {
        switch self {
        case .ssdp, .room:
            return true
        default:
            return false
        }
    }
}

class CacheManager {
    
    static let shared = CacheManager()
    
    private var documentPath: URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    private func urlForKey(_ key: CacheKey, _ item: String?) -> URL? {
        var keyString = key.rawValue.cleanKey
        if let item = item {
            keyString += "-\(item.cleanKey)"
        }
        return documentPath?.appendingPathComponent(keyString)
    }
    
    func set(_ data: Data?, for key: CacheKey, item: String? = nil) {
        guard let url = self.urlForKey(key, item) else { return }
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func set<T: Codable>(object: T, for key: CacheKey, item: String? = nil) throws {
        let data = try JSONEncoder().encode(object)
        set(data, for: key, item: item)
    }
    
    func get(for key: CacheKey, item: String? = nil) -> Data? {
        guard let url = self.urlForKey(key, item),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func getObject<T: Codable>(for key: CacheKey, item: String? = nil) -> T? {
        guard let data: Data = get(for: key, item: item),
              let object: T = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return object
    }
    
    func clear(removeLongCache: Bool = false) {
        let exclude = removeLongCache ? [] : CacheKey.allCases.filter({ $0.isLongCache }).map({ $0.rawValue })
        guard let documentPath = documentPath,
            let result = try? FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil).filter({ !$0.lastPathComponent.has(prefix: exclude) }) else { return }
        
        result.forEach { (url) in
            if !exclude.contains(url.lastPathComponent) {
                try? FileManager.default.removeItem(at: url)
            }
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
    
    func has(prefix: [String]) -> Bool {
        return prefix.filter({ self.hasPrefix($0) }).count > 0
    }
}
