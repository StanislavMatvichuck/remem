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
    var goalsInputView: UIView { viewRoot.week }
    // MARK: - Properties
    let viewRoot: EventDetailsView
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
        self.viewRoot = EventDetailsView(viewModel: viewModel)
        self.coordinator = coordinator
        self.useCase = useCase

        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)

        configureEventsHandlers()
        title = viewModel.event.name /// move title to viewModel
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        useCase.visit(viewModel.event)
    }

    // MARK: - Private
    private func configureEventsHandlers() {
        viewRoot.goalsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressAddGoal)))
    }

    private func contain(controller: UIViewController, in view: UIView) {
        addChild(controller)
        view.addAndConstrain(controller.view)
        controller.didMove(toParent: self)
    }

    @objc private func onPressAddGoal() {
        UIDevice.vibrate(.medium)
        viewRoot.goalsButton.animate()
        coordinator?.showGoalsInput(event: viewModel.event)
    }
}

extension EventDetailsController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        viewModel = EventDetailsViewModel(event: event)
    }
}
