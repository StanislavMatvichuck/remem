//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsView: UIView {
    static var margin: CGFloat = 2 * .delta1

    private lazy var title: UILabel = {
        let label = UILabel(al: true)
        label.text = "Settings"
        label.textColor = .label
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        return label
    }()

    let onboardingButton = SettingsRowView("Watch onboarding")
    let reminderInput = ReminderInputView()

    private lazy var footer: UILabel = {
        let label = UILabel(al: true)
        label.textColor = .label
        label.font = .systemFont(ofSize: 0.6 * .font1)
        label.text = "Made with ❤️ in 🇺🇦"

        addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = SettingsView.margin

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sm),
            stack.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
        ])
        return stack
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(onboardingButton)
        stackView.addArrangedSubview(reminderInput)

        footer.tag = 1
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIColor.systemBackground.cgColor
    }
}
