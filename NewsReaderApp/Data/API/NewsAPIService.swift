//
//  NewsAPIService.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 26.04.25.
//

import Foundation

protocol NewsAPIService {
    func fetchTopHeadlines(
        category: String,
        completion: @escaping (Result<[ArticleDTO], Error>) -> Void
    )
}
