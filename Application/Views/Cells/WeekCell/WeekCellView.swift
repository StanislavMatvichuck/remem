//
//  WeekCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.04.2023.
//

import UIKit

final class WeekCellView: UIView {
    static let spacing = CGFloat.buttonMargin / 8
    static let cornerRadius = CGFloat.buttonMargin / 4
    static let bottomDecalHeight = cornerRadius * 2
    static let happeningsDisplayedMaximumAmount = 6

    let bottomDecal: UIView = {
        let bottomDecal = UIView(al: true)
        bottomDecal.backgroundColor = .background
        bottomDecal.layer.cornerRadius = WeekCellView.bottomDecalHeight / 2
        return bottomDecal
    }()

    let day: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontSmallBold
        label.backgroundColor = UIColor.primary
        label.textColor = UIColor.text_secondary
        label.textAlignment = .center
        label.text = " "
        return label
    }()

    let timingLabels: [UILabel] = {
        func makeTimeLabel() -> UILabel {
            let newLabel = UILabel(al: true)
            newLabel.textAlignment = .center
            newLabel.font = .fontSmallBold
            newLabel.textColor = UIColor.text_primary
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.minimumScaleFactor = 0.1
            newLabel.numberOfLines = 1
            newLabel.backgroundColor = .clear
            newLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7 / 3).isActive = true
            newLabel.text = " "
            return newLabel
        }

        var result = [UILabel]()

        for _ in 0 ..< WeekCellView.happeningsDisplayedMaximumAmount { result.append(makeTimeLabel()) }

        return result
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureContent(_ vm: WeekCellViewModel) {
        day.text = vm.dayNumber
        day.font = vm.isToday ? .fontBold : .font

        show(timings: vm.items)
    }

    func prepareForReuse() {
        hideAll()
        day.text = " "
    }

    // MARK: - Private
    private func configureLayout() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = UIColor.background_secondary
        stack.layer.cornerRadius = Self.cornerRadius
        stack.clipsToBounds = true

        for timingLabel in timingLabels.reversed() {
            stack.addArrangedSubview(timingLabel)
        }

        day.addSubview(bottomDecal)
        NSLayoutConstraint.activate([
            bottomDecal.centerXAnchor.constraint(equalTo: day.centerXAnchor),
            bottomDecal.centerYAnchor.constraint(equalTo: day.bottomAnchor),
            bottomDecal.widthAnchor.constraint(equalTo: day.widthAnchor, multiplier: 0.6),
            bottomDecal.heightAnchor.constraint(equalToConstant: Self.bottomDecalHeight)
        ])

        stack.addArrangedSubview(day)

        addAndConstrain(stack, left: Self.spacing, right: Self.spacing, bottom: Self.spacing)
    }

    private func show(timings: [String]) {
        hideAll()

        let displayedTimes = timings.suffix(Self.happeningsDisplayedMaximumAmount).enumerated()

        for (index, time) in displayedTimes {
            timingLabels[index].text = time

            if index == 5 { timingLabels[5].text = "..." }
        }
    }

    private func hideAll() {
        for timingLabel in timingLabels { timingLabel.text = " " }
    }
}
