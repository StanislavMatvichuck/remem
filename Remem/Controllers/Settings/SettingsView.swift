//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsView: UIView {
    static var margin: CGFloat = 2 * .delta1

    let onboardingButton = SettingsRowView("Watch onboarding")
    let remindersButton = SettingsRowView("Configure reminders")

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
        stack.layer.cornerRadius = .delta1

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
        ])
        return stack
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)

        let separator = UIView(al: true)
        separator.backgroundColor = .opaqueSeparator
        separator.heightAnchor.constraint(equalToConstant: .hairline).isActive = true

        stackView.addArrangedSubview(remindersButton)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(onboardingButton)
        footer.tag = 1
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        stackView.layer.backgroundColor = UIColor.systemBackground.cgColor
    }
}
