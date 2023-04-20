//
//  TemporaryItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventItemView: UIView {
    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .fontSmallBold
        label.textColor = UIColor.text_primary
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .font
        label.textColor = UIColor.text_primary
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        return label
    }()

    let timeSinceContainer: UIView = {
        let dotColor = UIColor.background_secondary
        let backgroundColor = UIColor.secondary_dimmed
        let dotWidth = .buttonMargin / 3

        let leftDot = UIView(al: true)
        leftDot.backgroundColor = dotColor
        leftDot.layer.cornerRadius = dotWidth / 2

        let rightDot = UIView(al: true)
        rightDot.backgroundColor = dotColor
        rightDot.layer.cornerRadius = dotWidth / 2

        let corner = UIView(al: true)
        corner.backgroundColor = backgroundColor
        corner.layer.cornerRadius = .buttonMargin / 5

        let view = UIView(al: true)
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = .buttonMargin

        view.addSubview(corner)
        view.addSubview(leftDot)
        view.addSubview(rightDot)
        NSLayoutConstraint.activate([
            corner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            corner.topAnchor.constraint(equalTo: view.topAnchor),
            corner.widthAnchor.constraint(equalToConstant: .buttonMargin),
            corner.heightAnchor.constraint(equalToConstant: .buttonMargin),

            leftDot.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: .buttonMargin),
            leftDot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftDot.widthAnchor.constraint(equalToConstant: dotWidth),
            leftDot.heightAnchor.constraint(equalToConstant: dotWidth),

            rightDot.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -.buttonMargin),
            rightDot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightDot.widthAnchor.constraint(equalToConstant: dotWidth),
            rightDot.heightAnchor.constraint(equalToConstant: dotWidth),
        ])

        return view
    }()

    let timeSinceLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .fontSmall
        label.textColor = UIColor.text_secondary
        return label
    }()

    let circle: UIView = {
        let plusLayer: CAShapeLayer = {
            let plusSize = .buttonRadius / 5
            let center = CGFloat.buttonRadius - .buttonMargin

            let path = UIBezierPath()
            path.move(to: CGPoint(x: center - plusSize, y: center))
            path.addLine(to: CGPoint(x: center + plusSize, y: center))
            path.move(to: CGPoint(x: center, y: center - plusSize))
            path.addLine(to: CGPoint(x: center, y: center + plusSize))

            let plusLayer = CAShapeLayer()
            plusLayer.frame = CGRect(
                x: .zero, y: .zero,
                width: .buttonRadius * 2,
                height: .buttonRadius * 2
            )
            plusLayer.strokeColor = UIColor.background_secondary.cgColor
            plusLayer.path = path.cgPath
            plusLayer.lineCap = .round
            plusLayer.lineWidth = 4.0
            return plusLayer
        }()

        let view = UIView(al: true)
        view.backgroundColor = .primary
        view.layer.addSublayer(plusLayer)
        view.layer.cornerRadius = .buttonRadius - .buttonMargin
        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(_ viewModel: EventItemViewModel) {
        nameLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        timeSinceLabel.text = viewModel.timeSince
        viewModel.hintEnabled ? addSwipingHint() : removeSwipingHint()
    }

    // MARK: - Private
    private func configureLayout() {
        let leftSection = UIView(al: true)
        leftSection.addSubview(circle)

        let valueBackground = UIView(al: true)
        valueBackground.backgroundColor = .background
        valueBackground.layer.cornerRadius = .buttonRadius - .buttonMargin

        let rightSection = UIView(al: true)
        rightSection.addSubview(valueBackground)
        rightSection.addSubview(valueLabel)

        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.backgroundColor = .background_secondary
        stack.addArrangedSubview(leftSection)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(rightSection)
        stack.layer.cornerRadius = .buttonRadius

        leftSection.layer.zPosition = 3
        nameLabel.layer.zPosition = 2
        rightSection.layer.zPosition = 1

        timeSinceContainer.addAndConstrain(timeSinceLabel, left: .buttonMargin, right: .buttonMargin)

        addSubview(stack)
        addSubview(timeSinceContainer)
        NSLayoutConstraint.activate([
            leftSection.widthAnchor.constraint(equalToConstant: 2 * .buttonRadius),
            rightSection.widthAnchor.constraint(equalToConstant: 2 * .buttonRadius),

            circle.widthAnchor.constraint(equalTo: valueBackground.widthAnchor),
            circle.heightAnchor.constraint(equalTo: circle.widthAnchor),
            circle.centerXAnchor.constraint(equalTo: leftSection.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: leftSection.centerYAnchor),

            valueLabel.widthAnchor.constraint(equalToConstant: 2 * .buttonRadius),
            valueLabel.heightAnchor.constraint(equalToConstant: 2 * .buttonRadius),
            valueLabel.centerXAnchor.constraint(equalTo: rightSection.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: rightSection.centerYAnchor),

            valueBackground.widthAnchor.constraint(equalTo: rightSection.widthAnchor, constant: .buttonMargin * -2),
            valueBackground.heightAnchor.constraint(equalTo: valueBackground.widthAnchor),
            valueBackground.centerXAnchor.constraint(equalTo: rightSection.centerXAnchor),
            valueBackground.centerYAnchor.constraint(equalTo: rightSection.centerYAnchor),

            timeSinceContainer.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            timeSinceContainer.centerYAnchor.constraint(equalTo: stack.bottomAnchor),
            timeSinceContainer.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            timeSinceContainer.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),

            stack.heightAnchor.constraint(equalToConstant: .buttonHeight),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: .buttonMargin * -2),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let plus = circle.layer.sublayers?.first as? CAShapeLayer {
            plus.strokeColor = UIColor.background_secondary.cgColor
        }
    }
}
