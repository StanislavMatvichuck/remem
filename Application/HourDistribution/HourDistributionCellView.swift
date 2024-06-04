//
//  HourDistributionCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionCellView: UIStackView {
    var viewModel: HourDistributionCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    private let hour: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.33
        label.numberOfLines = 1
        return label
    }()

    private let flexibleBackground = {
        let view = UIView(al: true)
        return view
    }()

    private let spacer = {
        let view = UIView(al: true)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    private lazy var constraint: NSLayoutConstraint = {
        flexibleBackground.widthAnchor.constraint(
            equalTo: flexibleBackground.heightAnchor
        )
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .fill
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func layoutSubviews() {
        configureBackgroundHeight()
        configureCorners()
        super.layoutSubviews()
    }

    private func configureCorners() {
        flexibleBackground.layer.cornerRadius = bounds.width / 2
    }

    private func configureBackgroundHeight() {
        guard let viewModel else { return }
        hour.layoutIfNeeded()

        let hTotal = bounds.height
        let hHour = hour.bounds.height
        let constant = (hTotal - 2 * hHour) * viewModel.relativeLength

        constraint.constant = -constant
    }

    // MARK: - Private
    private func configureLayout() {
        addArrangedSubview(spacer)
        addArrangedSubview(flexibleBackground)
        addArrangedSubview(hour)
        constraint.isActive = true
    }

    private func configureAppearance() {
        hour.textColor = .secondary
        hour.font = .fontSmall

        flexibleBackground.layer.borderWidth = .border
        flexibleBackground.layer.borderColor = UIColor.border_secondary.cgColor
    }

    private func configureContent(_ vm: HourDistributionCellViewModel) {
        hour.text = vm.hours
        flexibleBackground.backgroundColor = vm.isHidden ? .bg_secondary_dimmed : .bg_secondary
        hour.font = vm.isCurrentHour ? .fontExtraSmallBold : .fontExtraSmall
        flexibleBackground.layer.borderWidth = vm.isCurrentHour ? .border * 2 : .border
    }
}
