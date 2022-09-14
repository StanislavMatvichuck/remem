//
//  GoalsInputFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import UIKit
import RememDomain

class GoalsInputFactory {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let goalEditUseCase: GoalEditUseCase
    let sourceView: UIView?
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory,
         goalEditUseCase: GoalEditUseCase,
         sourceView: UIView?,
         event: Event)
    {
        self.applicationFactory = applicationFactory
        self.goalEditUseCase = goalEditUseCase
        self.sourceView = sourceView
        self.event = event
    }

    func makeGoalsInputController() -> GoalsInputController {
        let viewModel = makeGoalsInputViewModel()
        let viewRoot = makeGoalsInputView(viewModel: viewModel)

        let controller = GoalsInputController(viewRoot: viewRoot, viewModel: viewModel)
        viewModel.delegate = controller

        makeNavigationController(for: controller)
        return controller
    }

    func makeGoalsInputViewModel() -> GoalsInputViewModel {
        let viewModel = GoalsInputViewModel(event: event, goalEditUseCase: goalEditUseCase)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    func makeGoalsInputView(viewModel: GoalsInputViewModel) -> GoalsInputView {
        let viewRoot = GoalsInputView(viewModel: viewModel)
        return viewRoot
    }

    func makeNavigationController(for controller: GoalsInputController) {
        let nav = ApplicationFactory.makeStyledNavigationController()
        nav.pushViewController(controller, animated: false)
        nav.preferredContentSize = CGSize(width: .wScreen, height: 250)
        nav.modalPresentationStyle = .popover

        if let pc = nav.presentationController { pc.delegate = controller }

        if let pop = nav.popoverPresentationController,
           let view = sourceView
        {
            pop.sourceView = view
            pop.sourceRect = CGRect(x: view.bounds.minX,
                                    y: view.bounds.minY,
                                    width: view.bounds.width,
                                    height: view.bounds.height - UIHelper.font.pointSize)
        }
    }
}
