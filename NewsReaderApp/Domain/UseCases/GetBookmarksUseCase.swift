//
//  GetBookmarksUseCase.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

protocol GetBookmarksUseCase {
    func execute() -> [News]
}

final class GetBookmarksUseCaseImpl: GetBookmarksUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute() -> [News] {
        repository.getBookmarks()
    }
    
    
}
