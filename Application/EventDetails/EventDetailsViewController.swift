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

        for controller in controllers { contain(controller: controller) }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.serve(VisitEventServiceArgument(date: .now))
    }

    private func contain(controller: UIViewController) {
        addChild(controller)
        viewRoot.scroll.viewContent.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
