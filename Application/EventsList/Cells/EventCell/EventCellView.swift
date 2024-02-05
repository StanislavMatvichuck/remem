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
    let animatedProgress = AnimatedProgressView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(_ vm: EventCellViewModel) {
        title.text = vm.title
        amountContainer.configure(vm)
        animatedProgress.configure(vm)
        timeSince.configure(vm.timeSince)
        vm.hintEnabled ? addSwipingHint() : removeSwipingHint()
    }

    // MARK: - Private
    private func configureLayout() {
        let circleSpacer = UIView(al: true)
        circleSpacer.widthAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        stack.addSubview(animatedProgress)
        stack.addArrangedSubview(circleSpacer)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(amountContainer)

        circleContainer.layer.zPosition = 3
        title.layer.zPosition = 2
        amountContainer.layer.zPosition = 1

        addSubview(stack)
        addSubview(timeSince)
        addAndConstrain(circleContainer)
        addSubview(fireDecal)

        NSLayoutConstraint.activate([
            timeSince.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            timeSince.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
            timeSince.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            timeSince.widthAnchor.constraint(equalTo: title.widthAnchor),

            stack.heightAnchor.constraint(equalToConstant: .buttonHeight),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: .buttonMargin * -2),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),

            animatedProgress.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            
            fireDecal.centerYAnchor.constraint(equalTo: centerYAnchor),
            fireDecal.trailingAnchor.constraint(equalTo: leadingAnchor),
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
