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
        button.setTitle(CreateGoalViewModel.createGoal, for: .normal)
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
        button.setTitleColor(UIColor.bg, for: .normal)
    }

    private func configureTapHandler() { button.addTarget(self, action: #selector(handleTap), for: .touchUpInside) }
    @objc private func handleTap() { service?.serve(CreateGoalServiceArgument(eventId: viewModel!.eventId, dateCreated: .now)) }
}
