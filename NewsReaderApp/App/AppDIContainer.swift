//
//  AppDIContainer.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 1.05.25.
//

import Foundation

final class AppDIContainer {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String ?? ""
    
    lazy var remoteHeadlinesRepository: RemoteHeadlinesRepository = {
        let apiService = NewsAPIServiceImpl(apiKey: apiKey)
        return RemoteHeadlinesRepositoryImpl(apiService: apiService)
    }()
    
    lazy var localHeadlinesRepository: LocalHeadlinesRepository = {
        LocalHeadlinesRepositoryImpl(cache: NewsCache.shared)
    }()
    
    lazy var fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase = {
        FetchTopHeadlinesUseCaseImpl(
            remoteRepository: remoteHeadlinesRepository,
            localRepository: localHeadlinesRepository
        )
    }()
    
    lazy var repository: NewsRepository = {
        let apiService = NewsAPIServiceImpl(apiKey: apiKey)
        let coreData = DatabaseManager.shared
        return NewsRepositoryImpl(apiService: apiService, coreData: coreData)
    }()
    
    lazy var saveNewsUseCase = SaveNewsToBookmarksUseCaseImpl(repository: repository)
    lazy var removeNewsUseCase = RemoveNewsFromBookmarksUseCaseImpl(repository: repository)
    lazy var getBookmarksUseCase = GetBookmarksUseCaseImpl(repository: repository)
}
