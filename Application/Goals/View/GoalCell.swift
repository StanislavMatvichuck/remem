//
//  GoalView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Domain
import UIKit

final class GoalCell: UICollectionViewCell {
    let createdAt: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        return label
    }()

    let leftToAchieve: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        return label
    }()

    let input = GoalInputView()
    let progress = GoalProgressView()
    var opaqueBg: UIView?

    var viewModel: GoalViewModel? { didSet {
        guard let viewModel else { return }
        createdAt.text = viewModel.readableDateCreated
        leftToAchieve.text = viewModel.readableLeftToAchieve
        progress.viewModel = viewModel
        input.viewModel = viewModel
        configureAppearance(viewModel.isAchieved)
        if let oldValue, oldValue.readableValue != viewModel.readableValue {
            progress.animateValueUpdate()
        }
    }}

    var deleteService: DeleteGoalService?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAppearance()
        isAccessibilityElement = true
        accessibilityIdentifier = UITestID.goal.rawValue
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Private
    private func configureLayout() {
        let opaqueBackgroundContainer = UIView(al: true)
        opaqueBackgroundContainer.addSubview(progress)
        opaqueBackgroundContainer.addSubview(input)
        opaqueBackgroundContainer.backgroundColor = .bg_secondary
        self.opaqueBg = opaqueBackgroundContainer
        NSLayoutConstraint.activate([
            progress.centerXAnchor.constraint(equalTo: opaqueBackgroundContainer.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: opaqueBackgroundContainer.centerYAnchor),
            progress.heightAnchor.constraint(equalTo: opaqueBackgroundContainer.heightAnchor, constant: -4 * .buttonMargin),
            input.centerXAnchor.constraint(equalTo: opaqueBackgroundContainer.centerXAnchor),
            input.bottomAnchor.constraint(equalTo: opaqueBackgroundContainer.bottomAnchor, constant: -.buttonMargin),
            input.widthAnchor.constraint(equalTo: opaqueBackgroundContainer.widthAnchor, constant: -2 * .buttonMargin)
        ])

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.addArrangedSubview(createdAt)
        stack.addArrangedSubview(opaqueBackgroundContainer)
        stack.addArrangedSubview(leftToAchieve)
        stack.spacing = .buttonMargin
        addAndConstrain(stack, top: .buttonMargin, bottom: .buttonMargin)
    }

    private func configureAppearance() {
        backgroundColor = .bg_secondary_dimmed
        layer.cornerRadius = CGFloat.buttonMargin

        createdAt.font = .font
        createdAt.textColor = .remem_bg
        leftToAchieve.font = .font
        leftToAchieve.textColor = .remem_bg
    }

    private func configureAppearance(_ isAchieved: Bool) {
        backgroundColor = isAchieved ? .bg_goal_achieved_dimmed : .bg_secondary_dimmed
        layer.borderColor = isAchieved ? UIColor.text_goalAchieved.cgColor : UIColor.remem_secondary.cgColor
        opaqueBg?.backgroundColor = isAchieved ? UIColor.bg_goal_achieved : UIColor.bg_secondary
    }
}
