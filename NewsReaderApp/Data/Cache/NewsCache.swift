//
//  NewsCache.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 1.05.25.
//

import Foundation

final class NewsCache {
    static let shared = NewsCache()
    
    private init() {}
    
    private var storage: [String: (data: [News], timestamp: Date)] = [:]
    private let queue = DispatchQueue(label: "cache", attributes: .concurrent)
    
    func save(_ articles: [News], for category: String) {
        queue.async(flags: .barrier) {
            self.storage[category] = (articles, Date())
        }
    }
    
    func getCashedArticles(for category: String) -> [News]? {
        var result: [News]?
        queue.sync {
            if let cached = self.storage[category], isCacheValid(cached.timestamp) {
                result = cached.data
            }
        }
        return result
    }
    
    func clear() {
        queue.async(flags: .barrier) {
            self.storage.removeAll()
        }
    }
    
    func isCacheValid(_ timestamp: Date, cacheLifetime: TimeInterval = 60 * 5) -> Bool {
        return Date().timeIntervalSince(timestamp) < cacheLifetime
    }
    
}
