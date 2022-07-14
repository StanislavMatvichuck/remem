//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class CountableEventDetailsController: UIViewController {
    // MARK: - Properties
    var countableEvent: CountableEvent

    let clockController: ClockController
    let happeningsListController: CountableEventHappeningDescriptionsListController
    let beltController: BeltController
    let weekController: WeekController

    let notificationsService = LocalNotificationsService()
    var lockScreenNotificationMustBeAdded = false
    var lockScreenNotificationId: String?

    // MARK: - Init
    init(countableEvent: CountableEvent,
         clockController: ClockController,
         happeningsListController: CountableEventHappeningDescriptionsListController,
         weekController: WeekController,
         beltController: BeltController)
    {
        self.countableEvent = countableEvent
        self.clockController = clockController
        self.happeningsListController = happeningsListController
        self.beltController = beltController
        self.weekController = weekController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    private let viewRoot = CountableEventDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = countableEvent.name

        notificationsService.delegate = self
        notificationsService.requestSettings()

        setupClock()
        setupCountableEventHappeningDescriptionsList()
        setupBelt()
        setupWeek()

        setupAddToLockScreenButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let domain = DomainFacade()
        domain.visit(countableEvent: countableEvent)
    }
}

// MARK: - Private
extension CountableEventDetailsController {
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

    private func setupCountableEventHappeningDescriptionsList() {
        contain(controller: happeningsListController, in: viewRoot.happeningsList)
    }

    private func setupBelt() {
        beltController.countableEvent = countableEvent
        beltController.delegate = self
        contain(controller: beltController, in: viewRoot.belt)
    }

    private func setupWeek() {
        weekController.countableEvent = countableEvent
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
extension CountableEventDetailsController: LocalNotificationsServiceDelegate {
    var idString: String { countableEvent.objectID.uriRepresentation().absoluteString }

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

        notificationsService.addLockScreenNotification(text: countableEvent.name ?? "repeating notification text",
                                                       identifier: idString)
        lockScreenNotificationMustBeAdded = false
    }
}

// MARK: - BeltController delegate
extension CountableEventDetailsController: BeltControllerDelegate {
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
