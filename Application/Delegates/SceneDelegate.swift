//
//  SceneDelegate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var watcher: Watching?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let container = ApplicationContainer()
        window.rootViewController = container.makeRootViewController()
        window.makeKeyAndVisible()

        watcher = container.makeWatcher()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        watcher?.watch(.now)
    }
}
