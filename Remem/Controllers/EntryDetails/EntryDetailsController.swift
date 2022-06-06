//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController {
    // MARK: - Properties
    var entry: Entry!
    var coreDataService: EntryDetailsService!

    let clockController = ClockController()
    let pointsListController = PointsListController()
    let beltController = BeltController()
    let weekController = WeekController()

    let notificationsService = LocalNotificationsService()
    var lockScreenNotificationMustBeAdded = false
    var lockScreenNotificationId: String?

    // MARK: - View lifecycle
    private let viewRoot = EntryDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = entry.name

        notificationsService.delegate = self
        notificationsService.requestSettings()

        setupAddToLockScreenButton()
        setupClock()
        setupPointsList()
        setupBelt()
        setupWeek()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coreDataService.markAsVisited()
    }
}

// MARK: - Private
extension EntryDetailsController {
    private func setupAddToLockScreenButton() {
        let leftItem = UIBarButtonItem(title: "Add to lock screen",
                                       style: .plain,
                                       target: self,
                                       action: #selector(handlePressAddToLockScreen))
        navigationItem.leftBarButtonItem = leftItem
    }

    private func setupRemoveFromLockScreenButton() {
        let barItem = UIBarButtonItem(title: "Remove",
                                      style: .plain,
                                      target: self,
                                      action: #selector(handlePressRemoveFromLockScreen))
        navigationItem.leftBarButtonItem = barItem
    }

    private func setupClock() {
        clockController.freshPoint = entry.freshPoint
        contain(controller: clockController, in: viewRoot.clock)
    }

    private func setupPointsList() {
        contain(controller: pointsListController, in: viewRoot.pointsList)
    }

    private func setupBelt() {
        beltController.entry = entry
        contain(controller: beltController, in: viewRoot.belt)
    }

    private func setupWeek() {
        weekController.entry = entry
        contain(controller: weekController, in: viewRoot.week)
        weekController.delegate = clockController
    }

    private func contain(controller: UIViewController, in view: UIView) {
        addChild(controller)
        view.addAndConstrain(controller.view)
        controller.didMove(toParent: self)
    }
}

// MARK: - Lock screen notification handling
extension EntryDetailsController: LocalNotificationsServiceDelegate {
    var idString: String { entry.objectID.uriRepresentation().absoluteString }

    func localNotificationService(settings: UNNotificationSettings) {
        if settings.authorizationStatus == .authorized { notificationsService.requestLockScreenNotification(for: idString) }
    }

    func localNotificationService(authorized: Bool) {
        guard authorized else { return }
        addLockScreenNotificationIfNeeded()
        notificationsService.requestLockScreenNotification(for: idString)
    }

    func localNotificationServiceAddingRequestFinishedWith(error: Error?) {
        guard error == nil else { return }
        notificationsService.requestLockScreenNotification(for: idString)
    }

    func localNotificationService(lockScreenNotification: UNNotificationRequest?, for: String) {
        if let notification = lockScreenNotification {
            lockScreenNotificationId = notification.identifier
            setupRemoveFromLockScreenButton()
        } else {
            setupAddToLockScreenButton()
        }
    }

    private func addLockScreenNotificationIfNeeded() {
        guard lockScreenNotificationMustBeAdded else { return }

        notificationsService.addLockScreenNotification(text: entry.name ?? "repeating notification text",
                                                       identifier: idString)
        lockScreenNotificationMustBeAdded = false
    }

    @objc private func handlePressAddToLockScreen() {
        notificationsService.requestAuthorization()
        lockScreenNotificationMustBeAdded = true
    }

    @objc private func handlePressRemoveFromLockScreen() {
        guard let id = lockScreenNotificationId else { return }
        notificationsService.removePendingNotifications(id)
        notificationsService.requestLockScreenNotification(for: idString)
    }
}
