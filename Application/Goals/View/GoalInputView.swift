//
//  GoalInputView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2024.
//

import UIKit

final class GoalInputView: UIStackView {
    private static let buttonsSize: CGFloat = .buttonMargin * 5

    let minusBg = GoalInputView.makeSymbolImage(symbolName: "minus.circle.fill", variant: .inactive)
    let plusBg = GoalInputView.makeSymbolImage(symbolName: "plus.circle.fill", variant: .inactive)

    let minusAchieved = GoalInputView.makeSymbolImage(symbolName: "minus.circle.fill", variant: .inactiveAchieved)
    let plusAchieved = GoalInputView.makeSymbolImage(symbolName: "plus.circle.fill", variant: .inactiveAchieved)

    let minus = GoalInputView.makeSymbolImage(symbolName: "minus.circle.fill", variant: .active)
    let plus = GoalInputView.makeSymbolImage(symbolName: "plus.circle.fill", variant: .active)

    enum ButtonVariant {
        case inactive, inactiveAchieved, active
        var colors: [UIColor] { switch self {
        case .inactive: return [.bg_secondary, .green, .bg]
        case .inactiveAchieved: return [.bg_goal_achieved, .green, .bg]
        case .active: return [.bg, .green, .primary]
        }}
    }

    private static func makeSymbolImage(symbolName: String, variant: ButtonVariant) -> UIView {
        let configurationColors = UIImage.SymbolConfiguration(paletteColors: variant.colors)
        let fontConfiguration = configurationColors.applying(UIImage.SymbolConfiguration(pointSize: GoalInputView.buttonsSize))
        let image = UIImage(systemName: symbolName)?
            .withRenderingMode(.alwaysTemplate)
            .withConfiguration(fontConfiguration)
        let view = UIImageView(image: image)
        return view
    }

    var viewModel: GoalViewModel? { didSet {
        guard let viewModel else { return }
        plus.isHidden = viewModel.isAchieved
        minus.isHidden = viewModel.isAchieved || viewModel.readableValue == "1"

        plusAchieved.isHidden = !viewModel.isAchieved
        minusAchieved.isHidden = !viewModel.isAchieved
    }}

    var updateService: UpdateGoalService?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configureButtons()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        alignment = .center
        spacing = .buttonMargin

        let spacer = UIView(al: true)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addArrangedSubview(minusBg)
        addArrangedSubview(spacer)
        addArrangedSubview(plusBg)
        minusBg.addSubview(minusAchieved)
        minusBg.addSubview(minus)
        plusBg.addSubview(plusAchieved)
        plusBg.addSubview(plus)
        minus.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        plus.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }

    private func configureAppearance() {}

    private func configureButtons() {
        let plusGR = UITapGestureRecognizer(target: self, action: #selector(handleTapPlus))
        plus.addGestureRecognizer(plusGR)
        plus.isUserInteractionEnabled = true
        plus.isAccessibilityElement = true
        plus.accessibilityIdentifier = UITestAccessibilityIdentifier.buttonIncreaseGoalValue.rawValue

        plusBg.isUserInteractionEnabled = true
        plusBg.isAccessibilityElement = true

        let minusGR = UITapGestureRecognizer(target: self, action: #selector(handleTapMinus))
        minus.addGestureRecognizer(minusGR)
        minusBg.isUserInteractionEnabled = true
        minus.isUserInteractionEnabled = true
    }

    @objc private func handleTapPlus() {
        plus.animateTapReceiving()
        updateService?.serve(UpdateGoalServiceArgument(input: .plus))
    }

    @objc private func handleTapMinus() {
        minus.animateTapReceiving()
        updateService?.serve(UpdateGoalServiceArgument(input: .minus))
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
