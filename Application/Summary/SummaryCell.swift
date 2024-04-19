//
//  SummaryCell.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.02.2024.
//

import UIKit

final class SummaryCell: UICollectionViewCell {
    let title: UILabel = { UILabel(al: true) }()
    let value: UILabel = {
        let label = UILabel(al: true)
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = UITestAccessibilityIdentifier.summaryValue.rawValue
        return label
    }()

    let stack: UIStackView = {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    var viewModel: SummaryCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        title.numberOfLines = 2
        value.numberOfLines = 1
        contentView.addAndConstrain(stack)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(value)
        title.widthAnchor.constraint(equalTo: stack.widthAnchor, constant: -2 * .buttonMargin).isActive = true
        value.widthAnchor.constraint(equalTo: stack.widthAnchor, constant: -2 * .buttonMargin).isActive = true
    }

    private func configureAppearance() {
        stack.backgroundColor = .bg_secondary
//        stack.layer.borderColor = UIColor.secondary.cgColor
//        stack.layer.borderWidth = .border
        stack.layer.cornerRadius = .buttonMargin
        title.font = .font
        value.font = .fontWeekTitle
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.1
        value.textColor = .bg
        title.textColor = .bg
    }

    private func configureContent(_ vm: SummaryCellViewModel) {
        title.text = vm.title
        value.text = vm.value
    }
}
