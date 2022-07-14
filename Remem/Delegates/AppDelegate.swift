//
//  AppDelegate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        /// this call is made to avoid application reinstall
        registerCustomActions()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Code data
    let coreDataStack = CoreDataStack()

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.save(coreDataStack.defaultContext)
    }

    // MARK: - Local notifications
    private func registerCustomActions() {
        let add = UNNotificationAction(
            identifier: ActionIdentifier.add.rawValue,
            title: NSLocalizedString("notification.action.add", comment: "Notification actions"))

        let category = UNNotificationCategory(
            identifier: happeningsManipulcationNotificationsCategory,
            actions: [add],
            intentIdentifiers: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - Notifications actions handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let identity = response.notification.request.content.categoryIdentifier
        guard
            identity == happeningsManipulcationNotificationsCategory,
            let action = ActionIdentifier(rawValue: response.actionIdentifier),
            action == .add,
            let countableEventIdString = response.notification.request.content.userInfo["identifier"] as? String
        else { return }

        addCountableEventHappeningDescription(countableEventId: countableEventIdString)
    }

    private func addCountableEventHappeningDescription(countableEventId: String) {
        let domain = DomainFacade()
        guard let countableEvent = domain.countableEvent(by: countableEventId) else { return }
        domain.makeCountableEventHappeningDescription(for: countableEvent, dateTime: .now)
    }
}
