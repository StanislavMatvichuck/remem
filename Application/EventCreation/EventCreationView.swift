//
//  EventCreationView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import Foundation
import UIKit

final class EventCreationView: UIView {
    private let hint: UILabel = {
        let label = UILabel(al: true)
        label.text = EventCreationViewModel.hint
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let blur: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    let input: UITextField = {
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

    private let emoji = EmojiView()

    var emojiButtons: [UIButton] { emoji.viewContent.arrangedSubviews as! [UIButton] }

    private lazy var constraint: NSLayoutConstraint = {
        input.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
    }()

    var viewModel: EventCreationViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configureKeyboard()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        let margin = -2 * CGFloat.buttonMargin
        addAndConstrain(blur)
        addSubview(hint)
        addSubview(emoji)
        addSubview(input)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: centerXAnchor),
            emoji.centerXAnchor.constraint(equalTo: centerXAnchor),
            input.centerXAnchor.constraint(equalTo: centerXAnchor),
            hint.widthAnchor.constraint(equalTo: widthAnchor, constant: margin),
            emoji.widthAnchor.constraint(equalTo: widthAnchor),
            input.widthAnchor.constraint(equalTo: widthAnchor, constant: margin),
            input.heightAnchor.constraint(equalToConstant: .buttonHeight),

            hint.bottomAnchor.constraint(equalTo: emoji.topAnchor, constant: -.buttonMargin),
            emoji.bottomAnchor.constraint(equalTo: input.topAnchor, constant: -.buttonMargin),
            constraint
        ])
    }

    private func configureAppearance() {
        hint.font = .fontBold
        hint.textColor = .secondary
        input.backgroundColor = .bg_item
        input.layer.cornerRadius = .buttonHeight / 2
    }

    private func configureContent(_ vm: EventCreationViewModel) {
        if emoji.viewModel == nil { emoji.viewModel = vm }
        input.text = vm.createdEventName
    }

    // MARK: - Keyboard handling

    private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        animateKeyboard(visibility: true, notification)
    }

    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        animateKeyboard(visibility: false, notification)
    }

    private func animateKeyboard(visibility: Bool, _ notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }

        let animations = visibility ? {
            let keyboardMargin = CGFloat.buttonMargin
            let keyboardHeight = keyboardSize.cgRectValue.size.height
            let newConstant = -keyboardHeight - keyboardMargin
            self.constraint.constant = newConstant
            self.layoutIfNeeded()
        } : {
            self.constraint.constant = 0
            self.layoutIfNeeded()
        }

        UIViewPropertyAnimator(
            duration: duration,
            curve: curve,
            animations: animations
        ).startAnimation()
    }

    deinit { NotificationCenter.default.removeObserver(self) }
}
