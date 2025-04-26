//
//  RemoveNewsFromBookmarksUseCase.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

protocol RemoveNewsFromBookmarksUseCase {
    func execute(_ news: News)
}

final class RemoveNewsFromBookmarksUseCaseImpl: RemoveNewsFromBookmarksUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(_ news: News) {
        repository.removeFromBookmarks(news)
    }
    
    
}
