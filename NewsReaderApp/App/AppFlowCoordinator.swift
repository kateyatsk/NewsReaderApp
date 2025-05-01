//
//  AppFlowCoordinator.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 1.05.25.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
    private let container: AppDIContainer

    init(container: AppDIContainer) {
        self.container = container
    }

    func start() -> UITabBarController {
        let newsListVM = NewsListViewModel(
            fetchUseCase: container.fetchTopHeadlinesUseCase,
            getBookmarksUseCase: container.getBookmarksUseCase,
            removeBookmarkUseCase: container.removeNewsUseCase,
            saveBookmarkUseCase: container.saveNewsUseCase
        )
        let newsVC = NewsListViewController(viewModel: newsListVM)
        let newsNav = UINavigationController(rootViewController: newsVC)

        let bookmarksVM = BookmarksViewModel(
            getBookmarksUseCase: container.getBookmarksUseCase,
            removeUseCase: container.removeNewsUseCase,
            saveUseCase: container.saveNewsUseCase
        )
        let bookmarksVC = BookmarksViewController(viewModel: bookmarksVM)
        let bookmarksNav = UINavigationController(rootViewController: bookmarksVC)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [newsNav, bookmarksNav]
        tabBar.tabBar.barTintColor = .secondaryBackground
        tabBar.tabBar.tintColor = .primaryText
        tabBar.tabBar.isTranslucent = false

        return tabBar
    }
}
