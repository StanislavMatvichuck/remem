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

    private let viewRoot = EventDetailsView()
    private var viewModel: EventDetailsViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    private let editUseCase: EventEditUseCaseInput
    private let weekController: WeekController
    private let clockController: ClockController
    private let goalsInputController: GoalsInputController

    // MARK: - Init
    init(event: Event,
         editUseCase: EventEditUseCaseInput,
         clockController: ClockController,
         weekController: WeekController,
         goalsInputController: GoalsInputController)
    {
        self.event = event
        self.editUseCase = editUseCase
        self.weekController = weekController
        self.clockController = clockController
        self.goalsInputController = goalsInputController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = event.name

        contain(controller: weekController, in: viewRoot.week)
        contain(controller: clockController, in: viewRoot.clock)
        contain(controller: goalsInputController, in: viewRoot.goalsInput)

        viewModel = EventDetailsViewModel(event)
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
}
