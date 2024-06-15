//
//  WeekDayHappeningsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.12.2023.
//

import UIKit

final class WeekDayHappeningView: UIView {
    private let number: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontSmallBold
        label.textAlignment = .center
        return label
    }()

    private let background: UIView = {
        let view = UIView(al: true)
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4).isActive = true
        view.layer.cornerRadius = .layoutSquare / 10 * 1.6
        return view
    }()

    private var relativeLength: CGFloat = 0 { didSet { if oldValue != relativeLength { setNeedsLayout() }} }

    private lazy var animatedTopConstraint: NSLayoutConstraint = {
        number.topAnchor.constraint(equalTo: topAnchor, constant: 0)
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func layoutSubviews() {
        constrainNumberToRelativeLength()
        super.layoutSubviews()
    }

    func configureContent(_ viewModel: WeekDayViewModel) {
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
            background.centerXAnchor.constraint(equalTo: number.centerXAnchor),
            animatedTopConstraint
        ])
    }

    private func constrainNumberToRelativeLength() {
        number.layoutIfNeeded()

        let numberHeight = number.bounds.height
        let freeSpaceHeight = bounds.height - numberHeight
        let coefficient = 1 - relativeLength
        let constant = freeSpaceHeight * coefficient

        animatedTopConstraint.constant = constant
    }
}
