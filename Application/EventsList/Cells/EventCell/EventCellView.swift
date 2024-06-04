//
//  TemporaryItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventCellView: UIView {
    let stack: UIStackView = {
        let view = UIStackView(al: true)
        return view
    }()

    let title = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .font
        label.textColor = UIColor.text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = UITestID.eventTitle.rawValue
        return label
    }()

    let fireDecal: UILabel = {
        let label = UILabel(al: true)
        label.text = "🔥"
        label.font = .fontBold
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        return label
    }()

    let timeSince = TimeSinceView()
    let circleContainer = SwipingCircleView()
    let amountContainer = EventAmountView()
    let hintDisplay = SwipeHintDisplay()
    let goalIndicator = EventCellGoalIndicator()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Public
    func configure(_ vm: EventCellViewModel) {
        title.text = vm.title
        amountContainer.configure(vm)
        timeSince.configure(vm.timeSince)
        hintDisplay.configure(vm)
        goalIndicator.viewModel = vm.goal
    }

    func prepareForReuse() {
        circleContainer.prepareForReuse()
        hintDisplay.prepareForReuse()
    }

    // MARK: - Private
    private func configureLayout() {
        let circleSpacer = UIView(al: true)
        circleSpacer.widthAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        stack.addArrangedSubview(circleSpacer)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(amountContainer)

        hintDisplay.layer.zPosition = 4
        circleContainer.layer.zPosition = 3
        title.layer.zPosition = 2
        amountContainer.layer.zPosition = 1

        addSubview(stack)
        addSubview(timeSince)
        addSubview(circleContainer)
        addSubview(fireDecal)
        addAndConstrain(hintDisplay)
        addSubview(goalIndicator)

        NSLayoutConstraint.activate([
            goalIndicator.centerXAnchor.constraint(equalTo: amountContainer.centerXAnchor),
            goalIndicator.centerYAnchor.constraint(equalTo: amountContainer.centerYAnchor),
            goalIndicator.widthAnchor.constraint(equalTo: amountContainer.widthAnchor, constant: -.buttonMargin),
            goalIndicator.heightAnchor.constraint(equalTo: amountContainer.heightAnchor, constant: -.buttonMargin),

            timeSince.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            timeSince.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: -.border),
            timeSince.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            timeSince.widthAnchor.constraint(equalTo: title.widthAnchor, multiplier: 3 / 4),

            stack.heightAnchor.constraint(equalToConstant: .buttonHeight),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: .buttonMargin * -2),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),

            fireDecal.centerYAnchor.constraint(equalTo: centerYAnchor),
            fireDecal.trailingAnchor.constraint(equalTo: leadingAnchor),
            circleContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .buttonMargin),
            circleContainer.widthAnchor.constraint(equalToConstant: .buttonHeight),
            circleContainer.heightAnchor.constraint(equalToConstant: .buttonHeight),
        ])
    }

    private func configureAppearance() {
        stack.backgroundColor = .bg_item
        stack.layer.cornerRadius = .buttonRadius
        stack.clipsToBounds = true
        stack.layer.borderColor = UIColor.border.cgColor
        stack.layer.borderWidth = .border
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }
}
