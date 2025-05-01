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
    
    func save(_ articles: [News], for category: String) {
            storage[category] = (articles, Date())
        }
    
    func getCashedArticles(for category: String) -> [News]? {
        guard let cached = storage[category] else { return nil }
        return isCachedValid(cached.timestamp) ? cached.data : nil
    }
    
    func clear() {
        storage.removeAll()
    }
    
    func isCachedValid(_ timestamp: Date, cacheLifetime: TimeInterval = 60 * 5) -> Bool {
        return Date().timeIntervalSince(timestamp) < cacheLifetime
    }
    
}
