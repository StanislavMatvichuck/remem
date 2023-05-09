//
//  TemporaryItemView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventCellView: UIView {
    let title = EventCellView.makeLabel(numberOfLines: 3)
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

    let stack: UIStackView = {
        let view = UIStackView(al: true)
        return view
    }()

    // MARK: - Private
    private func configureLayout() {
        stack.addSubview(animatedProgress)
        stack.addArrangedSubview(circleContainer)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(amountContainer)

        circleContainer.layer.zPosition = 3
        title.layer.zPosition = 2
        amountContainer.layer.zPosition = 1

        addSubview(stack)
        addSubview(timeSince)
        NSLayoutConstraint.activate([
            timeSince.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            timeSince.centerYAnchor.constraint(equalTo: stack.bottomAnchor),
            timeSince.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            timeSince.widthAnchor.constraint(equalTo: title.widthAnchor),

            stack.heightAnchor.constraint(equalToConstant: .buttonHeight),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: .buttonMargin * -2),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),

            animatedProgress.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        stack.backgroundColor = .background_secondary
        stack.layer.cornerRadius = .buttonRadius
        stack.clipsToBounds = true
        stack.layer.borderColor = UIColor.border.cgColor
        stack.layer.borderWidth = .border
    }

    static func makeLabel(numberOfLines: Int) -> UILabel {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .font
        label.textColor = UIColor.text_primary
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = numberOfLines
        return label
    }
}
