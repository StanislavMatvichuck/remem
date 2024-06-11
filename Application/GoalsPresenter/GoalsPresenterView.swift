//
//  GoalsPresenterView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import UIKit

protocol GoalsPresenterViewModelFactoring { func makeGoalsPresenterViewModel() -> GoalsPresenterViewModel }

final class GoalsPresenterView: UIView {
    lazy var button = Button(title: vm.title)

    private let showGoalsService: ShowGoalsService
    private var vm: GoalsPresenterViewModel { didSet {
        button.update(title: vm.title)
    }}
    private let vmFactory: GoalsPresenterViewModelFactoring

    init(showGoalsService: ShowGoalsService, vmFactory: GoalsPresenterViewModelFactoring) {
        self.showGoalsService = showGoalsService
        self.vm = vmFactory.makeGoalsPresenterViewModel()
        self.vmFactory = vmFactory
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

extension GoalsPresenterView: Updating {
    func update() { vm = vmFactory.makeGoalsPresenterViewModel() }
}
