//
//  DayOfWeekCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekCellView: UIStackView {
    var viewModel: DayOfWeekCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = WeekPageView.daySpacing
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        configureBackgroundHeight()
        super.layoutSubviews()
    }

    private func configureBackgroundHeight() {
        guard let viewModel else { return }
        dayName.layoutIfNeeded()
        dayValue.layoutIfNeeded()
        percent.layoutIfNeeded()

        let hTotal = bounds.height
        let hName = dayName.bounds.height
        let hValue = dayValue.bounds.height
        let hPercent = percent.bounds.height
        let hRemaining = hTotal - hName - hValue - hPercent - 1 * WeekPageView.daySpacing

        constraint.constant = -hRemaining * viewModel.relativeLength
    }

    // MARK: - Private
    private let spacer: UIView = {
        let view = UIView(al: true)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    private let percent: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private let dayValue: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private let dayName: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private let flexibleBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    private lazy var constraint: NSLayoutConstraint = {
        dayValue.heightAnchor.constraint(equalTo: flexibleBackground.heightAnchor)
    }()

    private func configureLayout() {
        flexibleBackground.addSubview(dayValue)

        addArrangedSubview(spacer)
        addArrangedSubview(percent)
        addArrangedSubview(flexibleBackground)
        addArrangedSubview(dayName)

        setCustomSpacing(0, after: percent)

        NSLayoutConstraint.activate([
            dayValue.centerXAnchor.constraint(equalTo: flexibleBackground.centerXAnchor),
            dayValue.widthAnchor.constraint(equalTo: flexibleBackground.widthAnchor),
            dayValue.bottomAnchor.constraint(equalTo: flexibleBackground.bottomAnchor),

            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 2 * 7 / 3),
            constraint,
        ])
    }

    private func configureAppearance() {
        dayName.font = .font
        dayName.textColor = .secondary
        percent.font = .font
        percent.textColor = .secondary
        dayValue.font = .fontSmallBold
        dayValue.textColor = .bg_item
        flexibleBackground.backgroundColor = .bg_secondary
        flexibleBackground.layer.cornerRadius = .layoutSquare / 10 * 1.6
    }

    private func configureContent(_ vm: DayOfWeekCellViewModel) {
        percent.text = "\(vm.percent)"
        dayValue.text = "\(vm.value)"
        dayName.text = vm.shortDayName

        percent.isHidden = vm.isHidden
        dayValue.isHidden = vm.isHidden
        flexibleBackground.isHidden = vm.isHidden
    }
}
