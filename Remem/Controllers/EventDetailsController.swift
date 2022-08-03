//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

protocol EventDetailsControllerDelegate: AnyObject {
    func didUpdate(event: DomainEvent)
}

class EventDetailsController: UIViewController {
    // MARK: - Properties
    var event: DomainEvent
    weak var delegate: EventDetailsControllerDelegate?

    private let viewRoot = EventDetailsView()
    private let editUseCase: EventEditUseCase
//    private let clockController: ClockController
//    private let weekController: WeekController

    // MARK: - Init
    init(event: DomainEvent,
         editUseCase: EventEditUseCase)
//         clockController: ClockController,
//         weekController: WeekController)
    {
        self.event = event
        self.editUseCase = editUseCase
//        self.clockController = clockController
//        self.weekController = weekController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = event.name
//        contain(controller: clockController, in: viewRoot.clock)
        setupWeek()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editUseCase.visit(event)
    }
}

// MARK: - Private
extension EventDetailsController {
    private func setupWeek() {
//        weekController.event = event
//        contain(controller: weekController, in: viewRoot.week)
//        weekController.delegate = clockController
    }

    private func contain(controller: UIViewController, in view: UIView) {
        addChild(controller)
        view.addAndConstrain(controller.view)
        controller.didMove(toParent: self)
    }
}
