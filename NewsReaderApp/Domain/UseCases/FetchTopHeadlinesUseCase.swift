//
//  FetchTopHeadlinesUseCase.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

protocol FetchTopHeadlinesUseCase {
    func execute(
        category: String,
        completion: @escaping (Result<[News], Error>) -> Void
    )
}

final class FetchTopHeadlinesUseCaseImpl: FetchTopHeadlinesUseCase {
    private let repository: NewsRepository

    init(repository: NewsRepository) {
        self.repository = repository
    }

    func execute(
        category: String,
        completion: @escaping (Result<[News], Error>) -> Void
    ) {
        repository.fetchTopHeadlines(category: category, completion: completion)
    }
}
