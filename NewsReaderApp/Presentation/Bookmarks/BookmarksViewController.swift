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
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let emptyStateView: UILabel = {
        let label = UILabel()
        label.text = "No bookmarks yet"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
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
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        view.addSubviews(collectionView, emptyStateView)
        setupConstraints()
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    func bindViewModel() {
        viewModel.bookmarksDidChange = { [weak self] items in
            guard let self = self else { return }
            self.articles = items
            self.emptyStateView.isHidden = !items.isEmpty
            
            UIView.transition(
                with: self.collectionView,
                duration: 0.3,
                options: [.transitionCrossDissolve],
                animations: {
                    self.collectionView.reloadData()
                }
            )
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
    
    private func showDeletionMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = .secondaryBackground
        messageLabel.backgroundColor = .primaryText
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
        messageLabel.alpha = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.layer.borderWidth = 1.0
        messageLabel.layer.borderColor = UIColor.secondaryBackground.withAlphaComponent(0.6).cgColor

        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        UIView.animate(withDuration: 0.3) {
            messageLabel.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                messageLabel.alpha = 0
            }) { _ in
                messageLabel.removeFromSuperview()
            }
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
            self.showDeletionMessage("Заметка удалена")
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


