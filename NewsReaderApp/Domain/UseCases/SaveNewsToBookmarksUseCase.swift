//
//  SaveNewsToBookmarksUseCase.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

protocol SaveNewsToBookmarksUseCase {
    func execute(_ news: News)
}

final class SaveNewsToBookmarksUseCaseImpl: SaveNewsToBookmarksUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(_ news: News) {
        repository.saveToBookmarks(news)
    }
    
    
}
