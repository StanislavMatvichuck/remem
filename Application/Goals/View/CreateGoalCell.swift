//
//  CreateGoalCell.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import UIKit

final class CreateGoalCell: UICollectionViewCell {
    let button = Button(title: CreateGoalViewModel.createGoal)

    var viewModel: CreateGoalViewModel?
    var service: CreateGoalService?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAccessibility()
        configureLayout()
        configureTapHandler()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    private func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityIdentifier = UITestID.buttonCreateGoal.rawValue
    }

    private func configureLayout() {
        contentView.addAndConstrain(
            button,
            top: .buttonMargin,
            bottom: .buttonMargin
        )
    }

    private func configureTapHandler() {
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        guard let service = service, let eventId = viewModel?.eventId else { return }

        animateTapReceiving {
            service.serve(CreateGoalServiceArgument(eventId: eventId, dateCreated: .now))
        }
    }
}
