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
    var event: Event
    var viewModel: EventDetailsViewModel

    // MARK: - Init
    init(
        event: Event,
        useCase: EventEditUseCasing,
        controllers: [UIViewController])
    {
        self.event = event
        self.viewModel = EventDetailsViewModel(event: event)
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
        useCase.visit(event)
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
