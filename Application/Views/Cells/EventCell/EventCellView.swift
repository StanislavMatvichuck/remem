//
//  TemporaryItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventCellView: UIView {
    static let width = CGFloat.layoutSquare * 7 - 2 * CGFloat.buttonMargin

    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .font
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

    let animatedProgress: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .secondary_dimmed
        view.layer.cornerRadius = .buttonHeight / 2
        view.layer.opacity = 0.4
        return view
    }()

    let timeSince = TimeSinceView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private var progress: CGFloat = 0
    private var animatedProgressConstraint: NSLayoutConstraint?

    // MARK: - Public
    func configure(_ viewModel: EventCellViewModel) {
        nameLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        timeSince.configure(viewModel.timeSince)
        viewModel.hintEnabled ? addSwipingHint() : removeSwipingHint()
        progress = viewModel.progress
        moveProgress()
    }

    func moveProgress() {
        let translation = (Self.width * progress).clamped(to: 0 ... Self.width)
        animatedProgressConstraint?.constant = translation
    }

    func prepareForReuse() { progress = 0 }

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
        stack.clipsToBounds = true
        stack.addSubview(animatedProgress)

        stack.addArrangedSubview(leftSection)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(rightSection)
        stack.layer.cornerRadius = .buttonRadius

        leftSection.layer.zPosition = 3
        nameLabel.layer.zPosition = 2
        rightSection.layer.zPosition = 1

        let animatedProgressConstraint = animatedProgress.trailingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 0)
        self.animatedProgressConstraint = animatedProgressConstraint

        addSubview(stack)
        addSubview(timeSince)
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

            timeSince.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            timeSince.centerYAnchor.constraint(equalTo: stack.bottomAnchor),
            timeSince.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            timeSince.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),

            stack.heightAnchor.constraint(equalToConstant: .buttonHeight),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: .buttonMargin * -2),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),

            animatedProgress.widthAnchor.constraint(equalTo: stack.widthAnchor),
            animatedProgress.heightAnchor.constraint(equalTo: stack.heightAnchor),
            animatedProgress.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            animatedProgressConstraint,
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
