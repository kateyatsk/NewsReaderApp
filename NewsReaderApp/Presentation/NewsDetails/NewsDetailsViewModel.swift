//
//  NewsDetailsViewModel.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 30.04.25.
//

import Foundation

final class NewsDetailsViewModel {
    private let news: News
    private let getBookmarksUseCase: GetBookmarksUseCase
    private let removeUseCase: RemoveNewsFromBookmarksUseCase
    private let saveUseCase: SaveNewsToBookmarksUseCase
    
    var isBookmarked: Bool {
        getBookmarksUseCase.execute().contains(where: { $0.url == news.url })
    }
    
    var title: String { news.title }
    var author: String { "Author: \(news.author ?? "Unknown")" }
    var date: String { "Published: \(formattedDate(news.publishedAt))" }
    var content: String { news.content ?? news.description }
    
    var imageURL: URL? {
        guard let str = news.urlToImage else { return nil }
        return URL(string: str)
    }
    
    init(
        news: News,
        getBookmarksUseCase: GetBookmarksUseCase,
        removeUseCase: RemoveNewsFromBookmarksUseCase,
        saveUseCase: SaveNewsToBookmarksUseCase
    ) {
        self.news = news
        self.getBookmarksUseCase = getBookmarksUseCase
        self.removeUseCase = removeUseCase
        self.saveUseCase = saveUseCase
    }
    
    func toggleBookmark() {
        if isBookmarked {
            removeUseCase.execute(news)
        } else {
            saveUseCase.execute(news)
        }
        DatabaseManager.shared.saveContext()
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
