//
//  AppDIContainer.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 1.05.25.
//

import Foundation

final class AppDIContainer {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String ?? ""

    lazy var repository: NewsRepository = {
        let apiService = NewsAPIServiceImpl(apiKey: apiKey)
        let coreData = DatabaseManager.shared
        return NewsRepositoryImpl(apiService: apiService, coreData: coreData)
    }()

    lazy var fetchTopHeadlinesUseCase = FetchTopHeadlinesUseCaseImpl(repository: repository)
    lazy var saveNewsUseCase = SaveNewsToBookmarksUseCaseImpl(repository: repository)
    lazy var removeNewsUseCase = RemoveNewsFromBookmarksUseCaseImpl(repository: repository)
    lazy var getBookmarksUseCase = GetBookmarksUseCaseImpl(repository: repository)
}
