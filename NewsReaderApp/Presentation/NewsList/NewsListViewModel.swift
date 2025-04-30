//
//  NewsListViewModel.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

final class NewsListViewModel {
    let fetchUseCase: FetchTopHeadlinesUseCase
    let getBookmarksUseCase: GetBookmarksUseCase
    let removeBookmarkUseCase: RemoveNewsFromBookmarksUseCase
    let saveBookmarkUseCase: SaveNewsToBookmarksUseCase
    
    private(set) var bookmarks: [News] = []
    
    var articlesDidChange: (([News]) -> Void)?
    var bookmarksDidChange: (() -> Void)?
    var errorDidOccur: ((String) -> Void)?
    var isLoadingChange: ((Bool) -> Void)?

    
    init(
        fetchUseCase: FetchTopHeadlinesUseCase,
        getBookmarksUseCase: GetBookmarksUseCase,
        removeBookmarkUseCase: RemoveNewsFromBookmarksUseCase,
        saveBookmarkUseCase: SaveNewsToBookmarksUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.getBookmarksUseCase = getBookmarksUseCase
        self.removeBookmarkUseCase = removeBookmarkUseCase
        self.saveBookmarkUseCase = saveBookmarkUseCase
        self.bookmarks = getBookmarksUseCase.execute()
    }
    
    func load(category: String) {
        isLoadingChange?(true)
        fetchUseCase.execute(category: category) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingChange?(false)
                switch result {
                case .success(let news):
                    self.articlesDidChange?(news)
                case .failure(let error):
                    self.errorDidOccur?(error.localizedDescription)
                }
            }
        }
    }
    
    func isBookmarked(_ news: News) -> Bool {
        return bookmarks.contains(where: { $0.url == news.url })
    }
    
    func toggleBookmark(for news: News) {
        if isBookmarked(news) {
            removeBookmarkUseCase.execute(news)
        } else {
            saveBookmarkUseCase.execute(news)
        }
        bookmarks = getBookmarksUseCase.execute()
        bookmarksDidChange?()
    }
    
    func reloadBookmarks() {
        bookmarks = getBookmarksUseCase.execute()
        bookmarksDidChange?()
    }
    
}
