//
//  SceneDelegate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let root = CompositionRoot()
        let coordinator = root.makeCoordinator()
        let rootViewController = root.makeRootViewController(coordinator: coordinator)
        self.window = window
        self.coordinator = coordinator

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
