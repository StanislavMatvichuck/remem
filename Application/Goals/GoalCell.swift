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
        return label
    }()

    let leftToAchieve: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        return label
    }()

    let input = GoalInputView()
    let progress = GoalProgressView()

    var viewModel: GoalViewModel? { didSet {
        guard let viewModel else { return }
        configure(content: viewModel)
    } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        let horizontalStack = UIStackView(al: true)
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.addArrangedSubview(createdAt)
        stack.addArrangedSubview(input)
        stack.addArrangedSubview(leftToAchieve)
        stack.spacing = .buttonMargin
        horizontalStack.addArrangedSubview(stack)
        horizontalStack.addArrangedSubview(progress)
        horizontalStack.alignment = .center
        progress.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 1 / 5).isActive = true
        addAndConstrain(horizontalStack, constant: .buttonMargin)
    }

    private func configureAppearance() {
        backgroundColor = .bg_secondary
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondary.cgColor
        layer.cornerRadius = CGFloat.buttonMargin

        createdAt.font = .font
        createdAt.textColor = .bg
        leftToAchieve.font = .font
        leftToAchieve.textColor = .text_secondary
    }

    private func configure(content vm: GoalViewModel) {
        createdAt.text = vm.readableDateCreated
        leftToAchieve.text = vm.readableLeftToAchieve
    }
}
