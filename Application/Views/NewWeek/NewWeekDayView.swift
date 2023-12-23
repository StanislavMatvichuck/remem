//
//  NewWeekDayView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.12.2023.
//

import UIKit

final class NewWeekDayView: UIView {
    let dayName: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        return label
    }()

    let dayNumber: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        return label
    }()

    let dayNumberContainer: UIView = {
        let view = UIView(al: true)
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()

    let happeningsDisplayBackground: UIView = {
        let view = UIView(al: true)
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3).isActive = true
        return view
    }()

    var viewModel: NewWeekDayViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        let clippingStack = UIStackView(al: true)
        clippingStack.axis = .vertical
        clippingStack.alignment = .center
        clippingStack.addArrangedSubview(happeningsDisplayBackground)
        clippingStack.addArrangedSubview(dayNumberContainer)
        clippingStack.layer.cornerRadius = NewWeekPageView.daySpacing / 2
        clippingStack.clipsToBounds = true

        let verticalStack = UIStackView(al: true)
        verticalStack.axis = .vertical
        verticalStack.alignment = .center

        dayNumberContainer.addSubview(dayNumber)
        dayNumber.centerXAnchor.constraint(equalTo: dayNumberContainer.centerXAnchor).isActive = true
        dayNumber.centerYAnchor.constraint(equalTo: dayNumberContainer.centerYAnchor).isActive = true

        verticalStack.addArrangedSubview(clippingStack)
        verticalStack.addArrangedSubview(dayName)

        happeningsDisplayBackground.widthAnchor.constraint(equalTo: verticalStack.widthAnchor).isActive = true
        dayNumberContainer.widthAnchor.constraint(equalTo: verticalStack.widthAnchor).isActive = true

        verticalStack.setCustomSpacing(NewWeekPageView.daySpacing, after: clippingStack)

        addAndConstrain(verticalStack)
    }

    private func configureAppearance() {
        dayNumberContainer.backgroundColor = .primary
        happeningsDisplayBackground.backgroundColor = .bg_item
        dayName.textColor = .secondary
        dayNumber.textColor = .bg_item
    }

    private func configureContent(_ viewModel: NewWeekDayViewModel) {
        dayName.text = viewModel.dayName
        dayNumber.text = viewModel.dayNumber
    }
}
