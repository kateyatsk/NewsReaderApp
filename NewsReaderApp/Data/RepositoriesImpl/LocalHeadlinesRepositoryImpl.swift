//
//  LocalHeadlinesRepositoryImpl.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 2.05.25.
//

import Foundation

final class LocalHeadlinesRepositoryImpl: LocalHeadlinesRepository {
    private let cache: NewsCache

    init(cache: NewsCache = .shared) {
        self.cache = cache
    }

    func getCachedHeadlines(for category: String) -> [News]? {
        return cache.getCashedArticles(for: category)
    }

    func saveHeadlines(_ headlines: [News], for category: String) {
        cache.save(headlines, for: category)
    }
}
