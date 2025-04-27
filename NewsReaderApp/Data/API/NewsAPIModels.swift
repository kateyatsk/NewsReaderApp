//
//  NewsAPIModels.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

struct NewsAPIResponse: Codable {
    let status: String
    let totalResult: Int
    let articles: [ArticleDTO]
}

struct ArticleDTO: Codable {
    let sourceDTO: SourceDTO
}

struct SourceDTO: Codable {
    let id: String?
    let name: String
}
