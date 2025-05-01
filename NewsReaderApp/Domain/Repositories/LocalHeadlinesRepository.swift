//
//  LocalHeadlinesRepository.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 2.05.25.
//

import Foundation

protocol LocalHeadlinesRepository {
    func getCachedHeadlines(for category: String) -> [News]?
    func saveHeadlines(_ headlines: [News], for category: String)
}
