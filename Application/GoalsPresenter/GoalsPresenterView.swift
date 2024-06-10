//
//  GoalsPresenterView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import UIKit

final class GoalsPresenterView: UIView {
    let button = Button(title: GoalsPresenterViewModel.create)

    private let showGoalsService: ShowGoalsService

    init(showGoalsService: ShowGoalsService) {
        self.showGoalsService = showGoalsService
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureTapHandler()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(button, constant: .buttonMargin)
    }

    private func configureTapHandler() {
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        button.animateTapReceiving {
            self.showGoalsService.serve(ApplicationServiceEmptyArgument())
        }
    }
}
