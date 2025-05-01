//
//  RemoteHeadlinesRepository.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 2.05.25.
//

import Foundation

protocol RemoteHeadlinesRepository {
    func fetchTopHeadlines(
        category: String,
        completion: @escaping (Result<[News], Error>) -> Void
    )
}
