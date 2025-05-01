//
//  NewsListViewController.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import UIKit

final class NewsListViewController: UIViewController {
    
    private let categories = NewsCategory.allCases
    private var selectedIndex = 0
    private var articles: [News] = []
    
    private let viewModel: NewsListViewModel
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Latest News"
        lbl.font = .systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = .primaryText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var categoryCollection: UICollectionView = {
        let layout = createCategoryLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            CategoryCell.self,
            forCellWithReuseIdentifier: CategoryCell.reuseIdentifier
        )
        cv.backgroundColor = .primaryBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(
            NewsCell.self,
            forCellWithReuseIdentifier: NewsCell.reuseIdentifier
        )
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .primaryBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .primaryBackground
        tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(titleLabel, categoryCollection, collectionView)
        setupConstraints()
        bindViewModel()
        viewModel.load(category: categories[selectedIndex].rawValue)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadBookmarks()
        collectionView.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.articlesDidChange = { [weak self] news in
            guard let cv = self?.collectionView else { return }
            UIView.transition(
                with: cv,
                duration: 0.4,
                options: [.transitionCrossDissolve],
                animations: {
                    self?.articles = news
                    cv.reloadData()
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            categoryCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            categoryCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            categoryCollection.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: categoryCollection.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func createCategoryLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .absolute(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
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
   
}

extension NewsListViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == categoryCollection {
            return categories.count
        } else {
            return articles.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == categoryCollection {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCell else { return UICollectionViewCell()}
            let text = categories[indexPath.item].displayName
            cell.configure(text: text, isSelected: indexPath.item == selectedIndex)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewsCell.reuseIdentifier,
                for: indexPath
            ) as! NewsCell
            let news = articles[indexPath.item]
            let isBookmarked = viewModel.isBookmarked(news)
            
            cell.configure(
                with: articles[indexPath.item],
                isBookmarked: isBookmarked
            ) {[weak self] in
                guard let self = self else { return }
                let newStatus = self.viewModel.toggleBookmark(for: news)
                cell.setBookmark(newStatus)
            }
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == categoryCollection {
                selectedIndex = indexPath.item
                categoryCollection.reloadData()
                let category = categories[selectedIndex].rawValue
                viewModel.load(category: category)
            } else {
                let selectedNews = articles[indexPath.item]
                let detailVM = NewsDetailsViewModel(
                    news: selectedNews,
                    getBookmarksUseCase: viewModel.getBookmarksUseCase,
                    removeUseCase: viewModel.removeBookmarkUseCase,
                    saveUseCase: viewModel.saveBookmarkUseCase
                )
                let detailVC = NewsDetailsViewController(viewModel: detailVM)
                navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
        
    }
    
