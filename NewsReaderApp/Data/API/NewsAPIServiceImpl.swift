//
//  NewsAPIServiceImpl.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 26.04.25.
//

import Foundation

final class NewsAPIServiceImpl: NewsAPIService {
    private let apiKey: String
    private let session: URLSession
    
    private let baseURL = "https://newsapi.org/v2"
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func fetchTopHeadlines(
        category: String,
        completion: @escaping (Result<[ArticleDTO], any Error>) -> Void
    ) {
        guard var components = URLComponents(string: "\(baseURL)/top-headlines") else {
            let error = NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid base URL"]
            )
            DispatchQueue.main.async{completion(.failure(error))}
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            let error = NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to build URL"]
            )
            DispatchQueue.main.async{completion(.failure(error))}
            return
        }
        
        print("Fetching URL: \(url.absoluteString)")
    }

}
