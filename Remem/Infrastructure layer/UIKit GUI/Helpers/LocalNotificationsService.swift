//
//  LocalNotificationsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.04.2022.
//

import UIKit

public let happeningsManipulcationNotificationsCategory = "HappeningsManipulation"

public enum ActionIdentifier: String {
    case add
}

protocol LocalNotificationsServiceDelegate: AnyObject {
    func localNotificationService(authorized: Bool)
    func localNotificationService(settings: UNNotificationSettings)
    func localNotificationService(pendingRequests: [UNNotificationRequest])
    func localNotificationServiceAddingRequestFinishedWith(error: Error?)
    func localNotificationService(lockScreenNotification: UNNotificationRequest?, for: String)
}

extension LocalNotificationsServiceDelegate {
    func localNotificationService(authorized: Bool) {}
    func localNotificationService(settings: UNNotificationSettings) {}
    func localNotificationService(pendingRequests: [UNNotificationRequest]) {}
    func localNotificationServiceAddingRequestFinishedWith(error: Error?) {}
    func localNotificationService(lockScreenNotification: UNNotificationRequest?, for: String) {}
}

// MARK: - Properties
class LocalNotificationsService {
    weak var delegate: LocalNotificationsServiceDelegate?
    private let center = UNUserNotificationCenter.current()
}

// MARK: - Public
extension LocalNotificationsService {
    func requestAuthorization() {
        center.requestAuthorization(options: [.providesAppNotificationSettings]) { [weak self] granted, error in
            if let error = error {
                print(error.localizedDescription)
            }

            DispatchQueue.main.async {
                self?.delegate?.localNotificationService(authorized: granted)
            }
        }
    }

    func requestSettings() {
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.delegate?.localNotificationService(settings: settings)
            }
        }
    }

    func requestPendingRequests() {
        center.getPendingNotificationRequests { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.localNotificationService(pendingRequests: result)
            }
        }
    }

    @discardableResult
    func addReminderNotification(
        text: String,
        hours: Int,
        minutes: Int,
        seconds: Int,
        repeats: Bool
    ) -> UNNotificationRequest {
        var components = DateComponents()
        components.hour = hours
        components.minute = minutes
        components.second = seconds

        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: repeats)

        let content = UNMutableNotificationContent()
        content.title = text
        content.sound = UNNotificationSound.default

        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        add(request: request)

        return request
    }

    @discardableResult
    func addLockScreenNotification(
        text: String,
        identifier: String
    ) -> UNNotificationRequest {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = text
        content.sound = .none
        content.interruptionLevel = .passive
        content.userInfo = ["identifier": identifier]
        content.categoryIdentifier = happeningsManipulcationNotificationsCategory

        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        add(request: request)

        return request
    }

    func requestLockScreenNotification(for identifier: String) {
        center.getPendingNotificationRequests { allNotifications in
            let notification = allNotifications.filter { request in
                guard let storedNotificationId = request.content.userInfo["identifier"] as? String else { return false }
                return storedNotificationId == identifier
            }.first

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.localNotificationService(lockScreenNotification: notification, for: identifier)
            }
        }
    }

    func removePendingNotifications(_ identifiers: String...) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

// MARK: - Private
extension LocalNotificationsService {
    private func add(request: UNNotificationRequest) {
        center.add(request) { [weak self] error in
            DispatchQueue.main.async {
                self?.delegate?.localNotificationServiceAddingRequestFinishedWith(error: error)
            }
        }
    }
}
