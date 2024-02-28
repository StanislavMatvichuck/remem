//
//  GoalInputView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2024.
//

import UIKit

final class GoalInputView: UIStackView {
    private static let buttonsSize: CGFloat = .buttonMargin * 3.2
    let input: GoalInput = {
        let field = GoalInput(al: true)
        field.text = "123"
        return field
    }()

    let minus: UIView = {
        let configurationColors = UIImage.SymbolConfiguration(paletteColors: [.bg, .green, .primary])
        let fontConfiguration = configurationColors.applying(UIImage.SymbolConfiguration(pointSize: GoalInputView.buttonsSize))
        let image = UIImage(systemName: "minus.square.fill")?
            .withRenderingMode(.alwaysTemplate)
            .withConfiguration(fontConfiguration)
        let view = UIImageView(image: image)
        return view
    }()

    let plus: UIView = {
        let configurationColors = UIImage.SymbolConfiguration(paletteColors: [.bg, .green, .primary])
        let fontConfiguration = configurationColors.applying(UIImage.SymbolConfiguration(pointSize: GoalInputView.buttonsSize))
        let image = UIImage(systemName: "plus.square.fill")?
            .withRenderingMode(.alwaysTemplate)
            .withConfiguration(fontConfiguration)
        let view = UIImageView(image: image)
        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        alignment = .center
        spacing = .buttonMargin

        let spacer = UIView(al: true)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addArrangedSubview(minus)
        addArrangedSubview(input)
        addArrangedSubview(plus)
        addArrangedSubview(spacer)
    }

    private func configureAppearance() {
        input.font = .fontBold
        input.textColor = UIColor.primary
        input.backgroundColor = UIColor.bg.withAlphaComponent(0.1)
        input.layer.cornerRadius = .buttonMargin
        input.layoutMargins = UIEdgeInsets(top: 0, left: .buttonMargin, bottom: 0, right: .buttonMargin)
    }
}

final class GoalInput: UITextField {
    var textPadding = UIEdgeInsets(
        top: .buttonMargin / 2,
        left: .buttonMargin,
        bottom: .buttonMargin / 2,
        right: .buttonMargin
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
