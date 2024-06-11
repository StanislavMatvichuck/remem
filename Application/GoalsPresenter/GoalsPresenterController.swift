//
//  GoalsPresenterController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import Domain
import UIKit

final class GoalsPresenterController: UIViewController {
    private let viewRoot: GoalsPresenterView
    private var goalCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var goalRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(view: GoalsPresenterView) {
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubscriptions()
    }

    deinit {
        goalCreatedSubscription = nil
        goalRemovedSubscription = nil
    }

    // MARK: - Private

    private func configureSubscriptions() {
        goalCreatedSubscription = DomainEventsPublisher.shared.subscribe(GoalCreated.self, usingBlock: { _ in
            self.viewRoot.update()
        })

        goalRemovedSubscription = DomainEventsPublisher.shared.subscribe(GoalDeleted.self, usingBlock: { _ in
            self.viewRoot.update()
        })
    }
}
