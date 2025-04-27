//
//  NewsRepositoryImpl.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 27.04.25.
//

import Foundation

final class NewsRepositoryImpl: NewsRepository {
    private let apiService: NewsAPIService
    
    init(apiService: NewsAPIService) {
        self.apiService = apiService
    }
    
    func fetchTopHeadlines(
        category: String,
        completion: @escaping (Result<[News], any Error>) -> Void
    ) {
        apiService.fetchTopHeadlines(category: category) { result in
            switch result {
            case .success(let dtos):
                let news = dtos.compactMap { dto -> News? in
                    guard
                        let title = dto.title,
                        let description = dto.description,
                        let url = dto.url,
                        let publishedAt = dto.publishedAt
                    else { return nil }
                    
                    return News(
                        title: title,
                        description: description,
                        url: url,
                        urlToImage: dto.urlToImage,
                        publishedAt: publishedAt,
                        source: dto.source.name,
                        author: dto.author,
                        content: dto.content
                    )
                }
                completion(.success(news))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveToBookmarks(_ news: News) {
        //
    }
    
    func removeFromBookmarks(_ news: News) {
        //
    }
    
    func getBookmarks() -> [News] {
        []
    }
    
    
}
