//
//  SceneDelegate.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 25.04.25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let container = AppDIContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let flow = AppFlowCoordinator(container: container)
        let rootVC = flow.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }
}
