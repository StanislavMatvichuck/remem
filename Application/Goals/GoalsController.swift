//
//  GoalsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Domain
import UIKit

final class GoalsController: UIViewController {
    let viewRoot: GoalsView
    var viewModel: GoalsViewModel? { didSet {
        viewRoot.viewModel = viewModel
    }}
    
    let factory: GoalsViewModelFactoring
    var goalCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalUpdatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    
    init(factory: GoalsViewModelFactoring, view: GoalsView) {
        self.factory = factory
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }
    deinit { goalCreatedSubscription = nil; goalDeletedSubscription = nil }
    
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureList()
        configureSubscriptions()
        
        viewModel = factory.makeGoalsViewModel()
    }
    
    // MARK: - Private
    
    private func configureList() {
        viewRoot.list.dragDelegate = self
        viewRoot.list.dropDelegate = self
        viewRoot.list.dragInteractionEnabled = true
    }
    
    private func configureSubscriptions() {
        let publisher = DomainEventsPublisher.shared
        goalCreatedSubscription = publisher.subscribe(GoalCreated.self, usingBlock: updateBlock)
        goalDeletedSubscription = publisher.subscribe(GoalDeleted.self, usingBlock: updateBlock)
        goalUpdatedSubscription = publisher.subscribe(GoalValueUpdated.self, usingBlock: updateBlock)
    }
    
    private var updateBlock: (_: DomainEventsPublisher.DomainEvent) -> Void { { [weak self] _ in self?.update() }}
}
