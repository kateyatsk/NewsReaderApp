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
        
        func finishWithError(_ error: Error) {
            DispatchQueue.main.async{completion(.failure(error))}
        }
        
        guard var components = URLComponents(string: "\(baseURL)/top-headlines") else {
            finishWithError(NewsAPIError.invalidBaseURL)
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            finishWithError(NewsAPIError.invalidRequestURL)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                finishWithError(NewsAPIError.network(error))
                return
            }
            
            if let code = (response as? HTTPURLResponse)?.statusCode,
               !(200...299).contains(code) {
                finishWithError(NewsAPIError.httpStatus(code: code))
                return
            }
            
            guard let data = data else {
                finishWithError(NewsAPIError.noData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let apiResponse = try decoder.decode(NewsAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(apiResponse.articles))
                }
                
            } catch {
                finishWithError(error)
            }
        }
        
        task.resume()
        
    }
    
}
