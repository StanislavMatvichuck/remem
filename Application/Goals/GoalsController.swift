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
    
    init(factory: GoalsViewModelFactoring, view: GoalsView) {
        self.factory = factory
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
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
        goalCreatedSubscription = DomainEventsPublisher.shared.subscribe(GoalCreated.self, usingBlock: { [weak self] _ in
            self?.update()
        })
        
        goalDeletedSubscription = DomainEventsPublisher.shared.subscribe(GoalDeleted.self, usingBlock: { [weak self] _ in
            self?.update()
        })
    }
}
