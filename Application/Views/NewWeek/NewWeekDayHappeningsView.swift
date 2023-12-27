//
//  NewWeekDayHappeningsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.12.2023.
//

import UIKit

final class NewWeekDayHappeningView: UIView {
    private let number: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontSmallBold
        label.textAlignment = .center
        return label
    }()

    private let background: UIView = {
        let view = UIView(al: true)
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4).isActive = true
        view.layer.cornerRadius = NewWeekPageView.daySpacing / 2
        return view
    }()

    private var relativeLength: CGFloat = 0

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        constrainNumberToRelativeLength()
        super.layoutSubviews()
    }

    func configureContent(_ viewModel: NewWeekDayViewModel) {
        relativeLength = viewModel.relativeLength
        let isHidden = !viewModel.hasHappenings
        number.isHidden = isHidden
        background.isHidden = isHidden
        number.text = viewModel.happeningsAmount
    }

    private func configureAppearance() {
        number.textColor = .bg_item
        background.backgroundColor = .bg_secondary
    }

    private func configureLayout() {
        addSubview(background)
        addSubview(number)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 3),
            number.widthAnchor.constraint(equalTo: widthAnchor),
            number.centerXAnchor.constraint(equalTo: centerXAnchor),
            background.widthAnchor.constraint(equalTo: widthAnchor),
            background.topAnchor.constraint(equalTo: number.topAnchor),
            background.centerXAnchor.constraint(equalTo: number.centerXAnchor)
        ])
    }

    private func constrainNumberToRelativeLength() {
        number.layoutIfNeeded()

        let numberHeight = number.bounds.height
        let freeSpaceHeight = bounds.height - numberHeight
        let coefficient = 1 - relativeLength
        let constant = freeSpaceHeight * coefficient

        number.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
    }
}
