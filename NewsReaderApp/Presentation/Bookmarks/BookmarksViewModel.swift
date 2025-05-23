//
//  BookmarksViewModel.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 29.04.25.
//

import Foundation

final class BookmarksViewModel {
    let getBookmarksUseCase: GetBookmarksUseCase
    let removeUseCase: RemoveNewsFromBookmarksUseCase
    let saveUseCase: SaveNewsToBookmarksUseCase
    
    var bookmarksDidChange: (([News]) -> Void)?
    var errorDidOccur: ((String) -> Void)?
    
    private var bookmarks: [News] = [] {
        didSet {
            bookmarksDidChange?(bookmarks)
        }
    }
    
    init(
        getBookmarksUseCase: GetBookmarksUseCase,
        removeUseCase: RemoveNewsFromBookmarksUseCase,
        saveUseCase: SaveNewsToBookmarksUseCase
    ) {
        self.getBookmarksUseCase = getBookmarksUseCase
        self.removeUseCase = removeUseCase
        self.saveUseCase = saveUseCase
    }
    
    func loadBookmarks() {
        let items = getBookmarksUseCase.execute()
        bookmarks = items
    }
    
    func removeBookmark(_ bookmark: News) {
        removeUseCase.execute(bookmark)
        loadBookmarks()
    }
    
}
