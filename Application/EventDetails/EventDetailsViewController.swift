//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import Domain
import UIKit

final class EventDetailsViewController: UIViewController {
    let factory: EventDetailsViewModelFactoring
    var viewModel: EventDetailsViewModel
    let service: VisitEventService
    let viewRoot: EventDetailsView
    private var happeningAddedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var happeningRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        factory: EventDetailsViewModelFactoring,
        controllers: [UIViewController],
        service: VisitEventService
    ) {
        self.service = service
        self.factory = factory
        self.viewModel = factory.makeEventDetailsViewModel()
        self.viewRoot = EventDetailsView()

        super.init(nibName: nil, bundle: nil)

        contain(controllers)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit {
        happeningAddedSubscription = nil
        happeningRemovedSubscription = nil
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        configureSubscriptions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.serve(VisitEventServiceArgument(date: .now))
    }

    private func contain(_ controllers: [UIViewController]) {
        for controller in controllers { contain(controller: controller) }
    }

    private func contain(controller: UIViewController) {
        addChild(controller)
        viewRoot.scroll.viewContent.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
    }

    private func configureSubscriptions() {
        happeningAddedSubscription = DomainEventsPublisher.shared.subscribe(HappeningCreated.self, usingBlock: { [weak self] _ in
            self?.update()
        })
        happeningRemovedSubscription = DomainEventsPublisher.shared.subscribe(HappeningRemoved.self, usingBlock: { [weak self] _ in
            self?.update()
        })
    }
}
