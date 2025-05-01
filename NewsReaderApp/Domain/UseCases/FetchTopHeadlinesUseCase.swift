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
    private let remoteRepository: RemoteHeadlinesRepository
    private let localRepository: LocalHeadlinesRepository
    
    init(
        remoteRepository: RemoteHeadlinesRepository,
        localRepository: LocalHeadlinesRepository
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func execute(
        category: String,
        completion: @escaping (Result<[News], Error>) -> Void
    ) {
        if let cached = localRepository.getCachedHeadlines(for: category) {
            completion(.success(cached))
            return
        }
        
        remoteRepository.fetchTopHeadlines(category: category) { [weak self] result in
            switch result {
            case .success(let headlines):
                self?.localRepository.saveHeadlines(headlines, for: category)
                completion(.success(headlines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
