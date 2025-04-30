//
//  NewsRepositoryImpl.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 27.04.25.
//

import Foundation
import CoreData

final class NewsRepositoryImpl: NewsRepository {
    private let apiService: NewsAPIService
    private let coreData: DatabaseManager
    
    init(apiService: NewsAPIService, coreData: DatabaseManager = .shared ) {
        self.apiService = apiService
        self.coreData = coreData
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
        let ctx = coreData.context
        
        let entity = SavedNews(context: ctx)
        entity.title = news.title
        entity.newsDescription = news.description
        entity.url = news.url
        entity.urlToImage = news.urlToImage
        entity.publishedAt = news.publishedAt
        entity.source = news.source
        entity.author = news.author
        entity.content = news.content
        
        coreData.saveContext()
    }
    
    func removeFromBookmarks(_ news: News) {
        let ctx = coreData.context
        
        let req: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        req.predicate = NSPredicate(format: "url == %@", news.url)
        
        if let items = try? ctx.fetch(req) {
            
            items.forEach(ctx.delete)
            coreData.saveContext()
        }
    }
    
    func getBookmarks() -> [News] {
        let ctx = coreData.context
        
        let req: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        
        let saved = (try? ctx.fetch(req)) ?? []
        
        return saved.map { e in
            News(
                title: e.title ?? "",
                description: e.newsDescription ?? "",
                url: e.url ?? "",
                urlToImage: e.urlToImage,
                publishedAt: e.publishedAt ?? Date(),
                source: e.source ?? "",
                author: e.author,
                content: e.content
            )
        }
       
   
    }
}
