//
//  NewsRepository.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

protocol NewsRepository {
    func saveToBookmarks(_ news: News)
    func removeFromBookmarks(_ news: News)
    func getBookmarks() -> [News]
}

