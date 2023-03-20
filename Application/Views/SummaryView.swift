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
        addAndConstrain(verticalStack)
    }

    private func configureAppearance() {
        backgroundColor = .clear
    }

    func configureContent(viewModel: SummaryViewModel) {
        removeAllRows()

        for item in viewModel.items {
            verticalStack.addArrangedSubview(
                makeRow(
                    left: makeAmountLabel(text: item.value, tag: item.valueTag, highlighted: item.belongsToUser),
                    right: makeLabel(text: item.title, tag: item.titleTag)
                )
            )
        }
    }

    private func removeAllRows() {
        for view in verticalStack.arrangedSubviews { view.removeFromSuperview() }
    }

    private func makeRow(left: UILabel, right: UILabel) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(left)
        stack.addArrangedSubview(right)

        left.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        right.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        left.widthAnchor.constraint(equalTo: right.widthAnchor, multiplier: 3 / 4).isActive = true

        return stack
    }

    private func makeLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel(al: true)
        label.font = .font
        label.textColor = UIColor.secondary
        label.text = text
        label.tag = tag
        return label
    }

    private func makeAmountLabel(text: String, tag: Int, highlighted: Bool) -> UILabel {
        let label = makeLabel(text: text, tag: tag)
        label.font = .fontBold
        label.textColor = highlighted ? .text_primary : .secondary
        label.textAlignment = .center
        return label
    }
}
