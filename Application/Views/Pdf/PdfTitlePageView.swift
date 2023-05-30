//
//  PdfTitlePageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 30.05.2023.
//

import UIKit

final class PdfTitlePageView: UIView {
    let title: UILabel = {
        let label = UILabel(al: true)
        label.text = PdfTitlePageViewModel.title
        return label
    }()

    let start: UILabel = {
        let label = UILabel(al: true)
        label.text = PdfTitlePageViewModel.start
        return label
    }()

    let finish: UILabel = {
        let label = UILabel(al: true)
        label.text = PdfTitlePageViewModel.finish
        return label
    }()

    let stack: UIStackView = {
        let verticalStack = UIStackView(al: true)
        verticalStack.axis = .vertical
        return verticalStack
    }()

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(_ vm: PdfTitlePageViewModel) {
        removeAllRows()

        stack.addArrangedSubview(makeRow(
            left: makeAmountLabel(text: "\(vm.eventTitle) \(PdfTitlePageViewModel.title)", tag: 0, highlighted: true),
            right: makeLabel(text: "", tag: 1)
        ))

        stack.addArrangedSubview(makeRow(
            left: makeAmountLabel(text: vm.readableStart, tag: 2, highlighted: true),
            right: makeLabel(text: PdfTitlePageViewModel.start, tag: 3)
        ))

        stack.addArrangedSubview(makeRow(
            left: makeAmountLabel(text: vm.readableFinish, tag: 4, highlighted: true),
            right: makeLabel(text: PdfTitlePageViewModel.finish, tag: 5)
        ))

        let spacer = UIView(al: true)
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        stack.addArrangedSubview(spacer)

        stack.addArrangedSubview(makeRow(
            left: makeAmountLabel(text: "By hour", tag: 6, highlighted: true),
            right: makeLabel(text: "", tag: 7)
        ))
    }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(stack, left: .buttonMargin, right: .buttonMargin)
    }

    private func removeAllRows() {
        for view in stack.arrangedSubviews { view.removeFromSuperview() }
    }

    private func configureAppearance() {}

    // MARK: - Copied from SummaryView
    private func makeRow(left: UILabel, right: UILabel) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(left)
        stack.addArrangedSubview(right)
        stack.setCustomSpacing(.buttonMargin, after: left)

        left.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        right.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        left.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return stack
    }

    private func makeLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel(al: true)
        label.font = .font
        label.textColor = UIColor.secondary
        label.text = text
        label.tag = tag
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.33
        label.numberOfLines = 1
        return label
    }

    private func makeAmountLabel(text: String, tag: Int, highlighted: Bool) -> UILabel {
        let label = makeLabel(text: text, tag: tag)
        label.font = .fontBold
        label.textColor = highlighted ? .text : .secondary
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.33
        label.numberOfLines = 1
        return label
    }
}
