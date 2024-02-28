//
//  GoalsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Foundation
import UIKit

final class GoalsView: UIView {
    let buttonCreateGoal: UIButton = {
        let button = UIButton(al: true)
        button.setTitle(GoalsViewModel.createGoal, for: .normal)
        return button
    }()

    let list: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        view.spacing = .buttonMargin
        return view
    }()

    var viewModel: GoalsViewModel? { didSet {
        guard let viewModel else { return }

        for subview in list.arrangedSubviews { subview.removeFromSuperview() }

        for cell in viewModel.cells {
            let cellView = GoalView()
            list.addArrangedSubview(cellView)
        }
    }}

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.addArrangedSubview(list)
        stack.addArrangedSubview(buttonCreateGoal)
        stack.spacing = .buttonMargin
        addAndConstrain(stack, constant: .buttonMargin)
        buttonCreateGoal.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
    }

    private func configureAppearance() {
        let color = UIColor.bg_primary
        buttonCreateGoal.backgroundColor = color
        buttonCreateGoal.layer.borderWidth = .border
        buttonCreateGoal.layer.borderColor = color.cgColor
        buttonCreateGoal.layer.cornerRadius = CGFloat.buttonMargin
        buttonCreateGoal.setTitleColor(UIColor.bg, for: .normal)
    }
}
