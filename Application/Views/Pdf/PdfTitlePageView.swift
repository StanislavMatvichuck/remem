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
        verticalStack.alignment = .fill
        return verticalStack
    }()

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(_ vm: PdfTitlePageViewModel) {
        let spacer = UIView(al: true)
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)

        removeAllRows()
        stack.addArrangedSubview(make(title: vm.eventTitle))
        stack.addArrangedSubview(makeAmountLabel(text: PdfTitlePageViewModel.start, highlighted: false))
        stack.addArrangedSubview(makeAmountLabel(text: vm.readableStart, highlighted: true))
        stack.addArrangedSubview(makeAmountLabel(text: PdfTitlePageViewModel.finish, highlighted: false))
        stack.addArrangedSubview(makeAmountLabel(text: vm.readableFinish, highlighted: true))
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(makeAmountLabel(text: "By hour", highlighted: true))
    }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(stack)
    }

    private func removeAllRows() {
        for view in stack.arrangedSubviews { view.removeFromSuperview() }
    }

    private func makeAmountLabel(text: String, highlighted: Bool) -> UILabel {
        let label = UILabel(al: true)
        label.font = .font
        label.textColor = UIColor.secondary
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.33
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .fontBold
        label.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        label.textColor = highlighted ? .text : .secondary
        return label
    }

    private func make(title: String) -> UIView {
        let label = UILabel(al: true)
        label.textColor = .bg
        label.font = .fontBoldBig
        label.text = title
        label.minimumScaleFactor = 0.2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1

        let container = UIView(al: true)
        container.backgroundColor = .primary
        container.addAndConstrain(label, left: .buttonMargin, right: .buttonMargin)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: .layoutSquare)
        ])

        return container
    }
}
