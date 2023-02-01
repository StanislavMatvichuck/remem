//
//  StatsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryView: UIView {
    private let verticalStack: UIStackView = {
        let stack = UIStackView(al: true)
        stack.spacing = UIHelper.spacing
        stack.axis = .vertical
        return stack
    }()

    init(viewModel: SummaryViewModel) {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configureContent(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addAndConstrain(verticalStack, constant: UIHelper.spacing)
    }

    private func configureAppearance() {
        backgroundColor = UIHelper.background
    }

    private func configureContent(viewModel: SummaryViewModel) {
        removeAllRows()

        for item in viewModel.items {
            verticalStack.addArrangedSubview(
                makeRow(
                    left: makeLabel(text: item.label, tag: item.labelTag),
                    right: makeAmountLabel(text: item.value, tag: item.valueTag)
                )
            )
        }

        verticalStack.addArrangedSubview(makeSpacing())
    }

    private func removeAllRows() {
        for view in verticalStack.arrangedSubviews { view.removeFromSuperview() }
    }

    private func makeSpacing() -> UIView {
        let spacing = UIView(al: true)
        spacing.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        return spacing
    }

    private func makeRow(left: UILabel, right: UILabel) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(left)
        stack.addArrangedSubview(right)
        stack.spacing = UIHelper.spacing

        left.widthAnchor.constraint(equalTo: right.widthAnchor, multiplier: 3).isActive = true

        return stack
    }

    private func makeLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel(al: true)
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.text = text
        label.tag = tag
        return label
    }

    private func makeAmountLabel(text: String, tag: Int) -> UILabel {
        let label = makeLabel(text: text, tag: tag)
        label.font = UIHelper.fontBold
        return label
    }
}
