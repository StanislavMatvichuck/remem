//
//  InputView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.05.2023.
//

import UIKit

final class InputView: UIView {
    let field: UITextField = {
        let input = UITextField(al: true)
        input.font = .font
        input.textAlignment = .center
        input.adjustsFontSizeToFitWidth = true
        input.minimumFontSize = UIFont.fontSmall.pointSize
        input.returnKeyType = .done
        input.isAccessibilityElement = true
        input.accessibilityIdentifier = "EventInput"
        return input
    }()

    let background = UIView(al: true)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        background.addSubview(field)
        NSLayoutConstraint.activate([
            field.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            field.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            field.heightAnchor.constraint(equalToConstant: .buttonHeight),
            field.widthAnchor.constraint(equalTo: background.widthAnchor, constant: -2 * .buttonHeight),
        ])

        addSubview(background)
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .buttonMargin),
            background.heightAnchor.constraint(equalToConstant: .buttonHeight),
            background.centerXAnchor.constraint(equalTo: centerXAnchor),
            background.centerYAnchor.constraint(equalTo: centerYAnchor),

            heightAnchor.constraint(equalTo: background.heightAnchor),
        ])
    }

    private func configureAppearance() {
        field.backgroundColor = .clear
        background.backgroundColor = .bg_item
        background.isOpaque = true

        background.layer.cornerRadius = .buttonRadius
        background.layer.borderColor = UIColor.border.cgColor
        background.layer.borderWidth = .border

        background.layer.shadowRadius = 30
        background.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
        background.layer.shadowOpacity = 1
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }
}
