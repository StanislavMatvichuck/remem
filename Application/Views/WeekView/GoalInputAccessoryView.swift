//
//  GoalInputAccessoryView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 03.05.2023.
//

import UIKit

// TODO: localization
final class GoalInputAccessoryView: UIStackView {
    static let buttonsRadius: CGFloat = WeekCellView.cornerRadius

    let done = make("Done")
    let minus = make("-1")
    let plus = make("+1")

    init() {
        super.init(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: UIScreen.main.bounds.width,
                height: .buttonHeight
            )
        ))

        axis = .horizontal
        alignment = .bottom
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(
            top: .buttonMargin,
            left: .buttonMargin,
            bottom: .buttonMargin,
            right: .buttonMargin
        )

        let background = UIView(al: true)
        background.backgroundColor = .bg_secondary

        let spacing = UIView(al: true)
        spacing.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let hint = UILabel(al: true)
        hint.text = "set zero to stop tracking"
        hint.font = .fontSmall
        hint.textColor = .bg

        let hintContainer = UIView(al: true)
        hintContainer.backgroundColor = .bg_secondary
        hintContainer.layer.cornerRadius = .buttonMargin
        hintContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        hintContainer.addAndConstrain(hint, left: .buttonMargin, right: .buttonMargin)

        addSubview(background)
        addArrangedSubview(minus)
        addArrangedSubview(plus)
        addArrangedSubview(spacing)
        addArrangedSubview(done)
        addSubview(hintContainer)

        NSLayoutConstraint.activate([
            hintContainer.heightAnchor.constraint(equalToConstant: .buttonMargin * 2),
            hintContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            hintContainer.topAnchor.constraint(equalTo: topAnchor),

            background.topAnchor.constraint(equalTo: hintContainer.bottomAnchor, constant: -1),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        setCustomSpacing(.buttonMargin, after: minus)

        configureAppearance()
        done.accessibilityIdentifier = UITestAccessibilityIdentifier.buttonGoalDone.rawValue
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func makeContainer() -> UIButton {
        let container = UIButton(al: true)
        container.backgroundColor = .bg
        container.layer.cornerRadius = Self.buttonsRadius
        return container
    }

    private static func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.font = .fontBold
        label.textColor = .primary
        label.text = text
        return label
    }

    private static func make(_ text: String) -> UIButton {
        let view = makeContainer()
        let label = makeLabel(text)
        view.addAndConstrain(label, left: .buttonMargin, right: .buttonMargin)
        return view
    }

    private func configureAppearance() {
        done.layer.cornerRadius = Self.buttonsRadius
        plus.layer.cornerRadius = Self.buttonsRadius
        minus.layer.cornerRadius = Self.buttonsRadius

        done.layer.borderWidth = .border
        plus.layer.borderWidth = .border
        minus.layer.borderWidth = .border

        done.layer.borderColor = UIColor.border.cgColor
        plus.layer.borderColor = UIColor.border.cgColor
        minus.layer.borderColor = UIColor.border.cgColor
    }
}
