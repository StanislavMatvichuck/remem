//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import Domain
import IosUseCases
import UIKit

class EventDetailsController: UIViewController {
    // MARK: - Properties
    let viewRoot = EventDetailsView()
    let useCase: EventEditUseCasing
    var viewModel: EventDetailsViewModel
    weak var coordinator: Coordinating?

    // MARK: - Init
    init(
        event: Event,
        useCase: EventEditUseCasing,
        coordinator: Coordinating,
        controllers: [UIViewController])
    {
        self.viewModel = EventDetailsViewModel(event: event)
        self.coordinator = coordinator
        self.useCase = useCase

        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)

        title = viewModel.event.name /// move title to viewModel

        for controller in controllers {
            contain(controller: controller)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        useCase.visit(viewModel.event)
    }

    private func contain(controller: UIViewController) {
        addChild(controller)
        viewRoot.scroll.viewContent.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension EventDetailsController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        // this has no visible result. used for event visit testing
        viewModel = EventDetailsViewModel(event: event)
    }
}
