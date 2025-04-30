//
//  BookmarksViewController.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 29.04.25.
//

import Foundation
import UIKit

final class BookmarksViewController: UIViewController {
    private var articles: [News] = []
    
    private let viewModel: BookmarksViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            NewsCell.self,
            forCellWithReuseIdentifier: NewsCell.reuseIdentifier
        )
        cv.backgroundColor = .primaryBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init(viewModel: BookmarksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Bookmarks"
        tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .primaryBackground
        view.addSubview(collectionView)
        setupConstraints()
        viewModel.loadBookmarks()
        bindViewModel()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBookmarks()
    }

}

private extension BookmarksViewController {
    
    func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(280)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func bindViewModel() {
        viewModel.bookmarksDidChange = { [weak self] items in
            self?.articles = items
            self?.collectionView.reloadData()
        }
        
        viewModel.errorDidOccur = { [weak self] message in
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "ОК", style: .default))
            self?.present(alert, animated: true)
            
        }
    }
    
    
}

extension BookmarksViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        articles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsCell.reuseIdentifier,
            for: indexPath
        ) as! NewsCell
        
        let news = articles[indexPath.item]
        cell.configure(with: news, isBookmarked: true) { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeBookmark(news)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = articles[indexPath.item]
        let detailVM = NewsDetailsViewModel(
            news: selectedNews,
            getBookmarksUseCase: viewModel.getBookmarksUseCase,
            removeUseCase: viewModel.removeUseCase, saveUseCase: viewModel.saveUseCase
        )
        let detailVC = NewsDetailsViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
        
}


