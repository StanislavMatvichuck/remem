//
//  WeekCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.04.2023.
//

import UIKit

final class WeekCellView: UIView {
    static let cornerRadius = CGFloat.buttonMargin / 2
    static let bottomDecalHeight = cornerRadius * 2
    static let happeningsDisplayedMaximumAmount = 6

    let dayContainer = WeekCellDayContainer()

    let day: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontSmallBold
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

    let stack: UIStackView = {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        return stack
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var stackSublayer: CALayer?

    // MARK: - View lifecycle
    override func draw(_ rect: CGRect) {
        if stackSublayer == nil {
            let borderLayer = CAShapeLayer()
            borderLayer.path = UIBezierPath(roundedRect: stack.bounds, cornerRadius: Self.cornerRadius).cgPath
            borderLayer.fillColor = UIColor.background_secondary.cgColor
            borderLayer.strokeColor = UIColor.border.cgColor
            borderLayer.lineWidth = .border
            stackSublayer = borderLayer
            stack.layer.insertSublayer(borderLayer, at: 0)
        }
    }

    // MARK: - Public
    func configureContent(_ vm: WeekCellViewModel) {
        day.text = vm.dayNumber
        day.font = vm.isToday ? .fontBold : .font

        let dayColor = vm.highlighted ? UIColor.primary : UIColor.primary_dimmed
        dayContainer.set(fill: dayColor, border: .goal_achieved)

        show(timings: vm.items)
    }

    func prepareForReuse() {
        hideAll()
        day.text = " "
    }

    // MARK: - Private
    private func configureLayout() {
        for timingLabel in timingLabels.reversed() {
            stack.addArrangedSubview(timingLabel)
        }

        dayContainer.addAndConstrain(day)
        stack.addArrangedSubview(dayContainer)
        dayContainer.layer.zPosition = 1

        addSubview(stack)
        stack.widthAnchor.constraint(equalTo: dayContainer.widthAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func configureAppearance() {
        stack.backgroundColor = UIColor.background_secondary
        stack.layer.cornerRadius = Self.cornerRadius
    }

    private func show(timings: [String]) {
        hideAll()

        let displayedTimes = timings.prefix(Self.happeningsDisplayedMaximumAmount)

        for (index, time) in displayedTimes.enumerated() {
            let reversedIndex = displayedTimes.count - 1 - index
            timingLabels[reversedIndex].text = time
        }
    }

    private func hideAll() {
        for timingLabel in timingLabels { timingLabel.text = " " }
    }
}
