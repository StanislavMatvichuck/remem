//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsController: UIViewController {
    // MARK: - Properties
    var event: Event

    let clockController: ClockController
    let happeningsListController: HappeningsListController
    let beltController: BeltController
    let weekController: WeekController

    let notificationsService = LocalNotificationsService()
    var lockScreenNotificationMustBeAdded = false
    var lockScreenNotificationId: String?

    // MARK: - Init
    init(event: Event,
         clockController: ClockController,
         happeningsListController: HappeningsListController,
         weekController: WeekController,
         beltController: BeltController)
    {
        self.event = event
        self.clockController = clockController
        self.happeningsListController = happeningsListController
        self.beltController = beltController
        self.weekController = weekController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    private let viewRoot = EventDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = event.name

        notificationsService.delegate = self
        notificationsService.requestSettings()

        setupClock()
        setupHappeningsList()
        setupBelt()
        setupWeek()

        setupAddToLockScreenButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let domain = DomainFacade()
        domain.visit(event: event)
    }
}

// MARK: - Private
extension EventDetailsController {
    private func setupAddToLockScreenButton() {
        beltController.installAddToLockScreenButton()
        relayoutCollectionView()
    }

    private func setupRemoveFromLockScreenButton() {
        beltController.installRemoveFromLockScreenButton()
        relayoutCollectionView()
    }

    private func relayoutCollectionView() {
        guard let view = weekController.view as? WeekView else { return }
        view.collection.collectionViewLayout.invalidateLayout()
    }

    private func setupClock() {
        contain(controller: clockController, in: viewRoot.clock)
    }

    private func setupHappeningsList() {
        contain(controller: happeningsListController, in: viewRoot.happeningsList)
    }

    private func setupBelt() {
        beltController.event = event
        beltController.delegate = self
        contain(controller: beltController, in: viewRoot.belt)
    }

    private func setupWeek() {
        weekController.event = event
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
extension EventDetailsController: LocalNotificationsServiceDelegate {
    var idString: String { event.objectID.uriRepresentation().absoluteString }

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

        notificationsService.addLockScreenNotification(text: event.name ?? "repeating notification text",
                                                       identifier: idString)
        lockScreenNotificationMustBeAdded = false
    }
}

// MARK: - BeltController delegate
extension EventDetailsController: BeltControllerDelegate {
    func didPressAddToLockScreen() {
        notificationsService.requestAuthorization()
        lockScreenNotificationMustBeAdded = true
    }

    func didPressRemoveFromLockScreen() {
        guard let id = lockScreenNotificationId else { return }
        notificationsService.removePendingNotifications(id)
        notificationsService.requestLockScreenNotification(for: idString)
    }
}
