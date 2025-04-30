//
//  SceneDelegate.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String ?? ""
        let apiService = NewsAPIServiceImpl(apiKey: apiKey)
        
        let databaseManager = DatabaseManager.shared
        let repository = NewsRepositoryImpl(
            apiService: apiService,
            coreData: databaseManager
        )
        
        let fetchHeadlinesUC = FetchTopHeadlinesUseCaseImpl(repository: repository)
        let saveBookmarkUC   = SaveNewsToBookmarksUseCaseImpl(repository: repository)
        let removeBookmarkUC = RemoveNewsFromBookmarksUseCaseImpl(repository: repository)
        let getBookmarksUC   = GetBookmarksUseCaseImpl(repository: repository)
        
        let newsListVM = NewsListViewModel(fetchUseCase: fetchHeadlinesUC)
        let newsListVC = NewsListViewController(
            viewModel: newsListVM,
            getBookmarksUseCase: getBookmarksUC,
            removeBookmarkUseCase: removeBookmarkUC,
            saveBookmarkUseCase: saveBookmarkUC
        )
        let newsNav = UINavigationController(rootViewController: newsListVC)
        
        let bookmarksVM = BookmarksViewModel(
            getBookmarksUseCase: getBookmarksUC,
            removeUseCase: removeBookmarkUC
        )
        let bookmarksVC = BookmarksViewController(viewModel: bookmarksVM)
        let bookmarksNav = UINavigationController(rootViewController: bookmarksVC)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [newsNav, bookmarksNav]
        
        tabBar.tabBar.barTintColor = .secondaryBackground
        tabBar.tabBar.tintColor = .primaryText
        tabBar.tabBar.isTranslucent = false          
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window
    }

}

