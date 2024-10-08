//
//  SceneDelegate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var dayChangeWatcher: Watching?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let launchMode = ApplicationContainer.parseLaunchMode()
        let container = ApplicationContainer(mode: launchMode)
        let service = container.makeShowEventsListService()
        service.serve(ApplicationServiceEmptyArgument())

        window.rootViewController = container.makeRootViewController()
        window.makeKeyAndVisible()

        dayChangeWatcher = container.makeDayWatcher()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        dayChangeWatcher?.watch(.now)
    }
}
