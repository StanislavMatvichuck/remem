//
//  LocalNotificationsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.04.2022.
//

import UIKit

protocol LocalNotificationsServiceDelegate {
    func authorizationRequest(result: Bool)
    func notificationsRequest(result: [UNNotificationRequest])
}

// MARK: - Properties
class LocalNotificationsService {
    var authorized: Bool?
    var delegate: LocalNotificationsServiceDelegate?
    private let center = UNUserNotificationCenter.current()
}

// MARK: - Public
extension LocalNotificationsService {
    func requestAuthorization() {
        center.requestAuthorization(
            options: [.badge, .sound, .alert]
        ) {
                [weak self] granted, error in

                if let error = error {
                    print(error.localizedDescription)
                }

                DispatchQueue.main.async {
                    self?.authorized = granted
                    self?.delegate?.authorizationRequest(result: granted)
                }
        }
    }

    func requestPendingNotifications() {
        if let delegate = delegate {
            center.getPendingNotificationRequests(
                completionHandler: delegate.notificationsRequest(result:))
        }
    }

    @discardableResult
    func addNotification(
        text: String,
        hours: Int,
        minutes: Int,
        seconds: Int,
        repeats: Bool) -> UNNotificationRequest
    {
        var components = DateComponents()
        components.hour = hours
        components.minute = minutes
        components.second = seconds
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: repeats)

        let content = UNMutableNotificationContent()
        content.title = text
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: 1)

        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        center.add(request) { error in print(error?.localizedDescription ?? "") }

        return request
    }

    func removePendingNotifications(_ identifiers: String...) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
