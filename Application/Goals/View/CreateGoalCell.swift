//
//  CreateGoalCell.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import UIKit

final class CreateGoalCell: UICollectionViewCell {
    let button: UIButton = {
        let button = UIButton(al: true)
        return button
    }()

    var viewModel: CreateGoalViewModel?
    var service: CreateGoalService?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAppearance()
        configureTapHandler()
        isAccessibilityElement = true
        accessibilityIdentifier = UITestAccessibilityIdentifier.buttonCreateGoal.rawValue
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() { contentView.addAndConstrain(button) }

    private func configureAppearance() {
        let color = UIColor.bg_primary
        button.backgroundColor = color
        button.layer.borderWidth = .border
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = CGFloat.buttonHeight / 2

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.font,
            NSAttributedString.Key.foregroundColor: UIColor.bg,
        ]

        button.setAttributedTitle(
            NSAttributedString(
                string: CreateGoalViewModel.createGoal,
                attributes: attributes
            ),
            for: .normal
        )
    }

    private func configureTapHandler() { button.addTarget(self, action: #selector(handleTap), for: .touchUpInside) }
    @objc private func handleTap() {
        animateTapReceiving {
            self.service?.serve(CreateGoalServiceArgument(eventId: self.viewModel!.eventId, dateCreated: .now))
        }
    }
}
