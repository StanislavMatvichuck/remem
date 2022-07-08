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
    var entry: Entry
    var coreDataService: EntryDetailsService

    let clockController: ClockController
    let pointsListController: PointsListController
    let beltController: BeltController
    let weekController: WeekController

    let notificationsService = LocalNotificationsService()
    var lockScreenNotificationMustBeAdded = false
    var lockScreenNotificationId: String?

    // MARK: - Init
    init(entry: Entry,
         service: EntryDetailsService,
         clockController: ClockController,
         pointsListController: PointsListController,
         weekController: WeekController,
         beltController: BeltController)
    {
        self.entry = entry
        self.clockController = clockController
        self.pointsListController = pointsListController
        self.beltController = beltController
        self.weekController = weekController
        self.coreDataService = service

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    private let viewRoot = EntryDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = entry.name

        notificationsService.delegate = self
        notificationsService.requestSettings()

        setupClock()
        setupPointsList()
        setupBelt()
        setupWeek()

        setupAddToLockScreenButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coreDataService.markAsVisited()
    }
}

// MARK: - Private
extension EntryDetailsController {
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

    private func setupPointsList() {
        contain(controller: pointsListController, in: viewRoot.pointsList)
    }

    private func setupBelt() {
        beltController.entry = entry
        beltController.delegate = self
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
}

// MARK: - BeltController delegate
extension EntryDetailsController: BeltControllerDelegate {
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
