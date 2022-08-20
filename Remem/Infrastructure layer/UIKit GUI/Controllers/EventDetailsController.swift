//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsController: UIViewController {
    // MARK: - Properties
    var event: Event
    weak var coordinator: Coordinator?

    private let viewRoot = EventDetailsView()
    private var viewModel: EventDetailsViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    private let editUseCase: EventEditUseCaseInput
    private let weekController: WeekController
    private let clockController: ClockController

    // MARK: - Init
    init(event: Event,
         editUseCase: EventEditUseCaseInput,
         clockController: ClockController,
         weekController: WeekController)
    {
        self.event = event
        self.editUseCase = editUseCase
        self.weekController = weekController
        self.clockController = clockController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = event.name

        contain(controller: weekController, in: viewRoot.week)
        contain(controller: clockController, in: viewRoot.clock)

        viewModel = EventDetailsViewModel(event)
        viewRoot.goalsInput.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressAddGoal)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visitIfNeeded()
    }
}

// MARK: - Private
extension EventDetailsController {
    private func contain(controller: UIViewController, in view: UIView) {
        addChild(controller)
        view.addAndConstrain(controller.view)
        controller.didMove(toParent: self)
    }

    private func visitIfNeeded() {
        if event.dateVisited == nil { editUseCase.visit(event) }
    }

    @objc private func onPressAddGoal(sender: UITapGestureRecognizer) {
        sender.view?.animate()
        UIDevice.vibrate(.medium)
        coordinator?.showGoalsInputController(event: event, sourceView: viewRoot.week)
    }
}
