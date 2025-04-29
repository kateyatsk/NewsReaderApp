//
//  NewsListViewModel.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import Foundation

final class NewsListViewModel {
    private let fetchUseCase: FetchTopHeadlinesUseCase
    
    var articlesDidChange: (([News]) -> Void)?
    var isLoadingChange: ((Bool) -> Void)?
    var errorDidOccur: ((String) -> Void)?
    
    init(fetchUseCase: FetchTopHeadlinesUseCase) {
        self.fetchUseCase = fetchUseCase
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
}
