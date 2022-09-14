//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import IOSInterfaceAdapters
import UIKit

class EventDetailsController: UIViewController {
    var goalsInputView: UIView { viewRoot.week }
    // MARK: - Properties
    private let viewRoot: EventDetailsView
    private let viewModel: EventDetailsViewModeling

    private let weekController: WeekController
    private let clockController: ClockController

    // MARK: - Init
    init(viewRoot: EventDetailsView,
         viewModel: EventDetailsViewModeling,
         clockController: ClockController,
         weekController: WeekController)
    {
        self.viewRoot = viewRoot
        self.viewModel = viewModel
        self.weekController = weekController
        self.clockController = clockController
        super.init(nibName: nil, bundle: nil)
        configureEventsHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        contain(controller: weekController, in: viewRoot.week)
        contain(controller: clockController, in: viewRoot.clock)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.visitIfNeeded()
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
        viewModel.showGoalsInput()
    }
}

extension EventDetailsController: EventDetailsViewModelDelegate {
    func update() { viewRoot.configureContent() }
}
