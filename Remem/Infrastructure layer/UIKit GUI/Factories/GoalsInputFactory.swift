//
//  GoalsInputFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import UIKit

class GoalsFactory {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let sourceView: UIView
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event, sourceView: UIView) {
        self.applicationFactory = applicationFactory
        self.sourceView = sourceView
        self.event = event
    }

    func makeGoalsInputController() -> GoalsInputController {
        let viewModel = makeGoalsInputViewModel()
        let viewRoot = makeGoalsInputView(viewModel: viewModel)

        let controller = GoalsInputController(viewRoot: viewRoot, viewModel: viewModel)
        viewModel.delegate = controller

        let nav = ApplicationFactory.makeStyledNavigationController()
        nav.pushViewController(controller, animated: false)
        nav.preferredContentSize = CGSize(width: .wScreen, height: 250)
        nav.modalPresentationStyle = .popover

        if let pc = nav.presentationController { pc.delegate = controller }
        if let pop = nav.popoverPresentationController {
            pop.sourceView = sourceView
            pop.sourceRect = CGRect(x: sourceView.bounds.minX,
                                    y: sourceView.bounds.minY,
                                    width: sourceView.bounds.width,
                                    height: sourceView.bounds.height - UIHelper.font.pointSize)
        }

        return controller
    }

    func makeGoalsInputViewModel() -> GoalsInputViewModel {
        let viewModel = GoalsInputViewModel(event: event, editUseCase: applicationFactory.eventEditUseCase)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    func makeGoalsInputView(viewModel: GoalsInputViewModel) -> GoalsInputView {
        let viewRoot = GoalsInputView(viewModel: viewModel)
        return viewRoot
    }
}
