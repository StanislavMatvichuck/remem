//
//  UIMovableTextView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.04.2022.
//

import UIKit

protocol EventInputing: UIControl {
    var value: String { get }

    func show(value: String)
    func rename(oldName: String)
    func hide()
}

final class EventInputView: UIControl {
    var value: String {
        get { inputContainer.field.text ?? "" }
        set { inputContainer.field.text = newValue }
    }

    var animationCompletionHandler: (() -> Void)?

    let background = BackgroundView()
    let inputContainer = InputView()
    let emojiContainer = EmojiView()

    /// Animated constraint that pins textField bottom to keyboard top
    lazy var constraint: NSLayoutConstraint = { emojiContainer.topAnchor.constraint(equalTo: bottomAnchor) }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false

        setupLayout()
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Private
    private func setupLayout() {
        addAndConstrain(background)
        addSubview(inputContainer)
        addSubview(emojiContainer)
        NSLayoutConstraint.activate([
            constraint,

            inputContainer.widthAnchor.constraint(equalTo: widthAnchor),
            inputContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiContainer.widthAnchor.constraint(equalTo: widthAnchor),
            emojiContainer.centerXAnchor.constraint(equalTo: centerXAnchor),

            emojiContainer.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -.buttonMargin),
        ])
    }

    private func setupEventHandlers() {
        inputContainer.field.delegate = self

        background.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handlePressCancel)
            )
        )

        inputContainer.field.addTarget(
            self,
            action: #selector(handleInputChange),
            for: .editingChanged
        )
        setupEmojiButtons()
        setupKeyboardNotificationsHandlers()
    }

    private func setupEmojiButtons() {
        if let emojiContainer = emojiContainer.subviews.first as? UIStackView,
           let emojiButtons = emojiContainer.arrangedSubviews as? [UIButton]
        {
            for button in emojiButtons {
                button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
            }
        }
    }

    private func setupKeyboardNotificationsHandlers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Public
extension EventInputView: EventInputing {
    func show(value: String) {
        self.value = value
        background.isHidden = false
        background.alpha = 0.0
        isUserInteractionEnabled = true
        inputContainer.field.becomeFirstResponder()

        if let emojiContainer = emojiContainer.subviews.first as? UIStackView {
            for (index, emoji) in emojiContainer.arrangedSubviews.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + 0.1 * Double(index)) {
                    emoji.animateEmoji()
                }
            }
        }
    }

    func rename(oldName: String) {
        show(value: oldName)
    }

    func hide() { handlePressCancel() }
}

// MARK: - Private
extension EventInputView {
    private func dismiss() {
        value = ""
        inputContainer.field.resignFirstResponder()
        isUserInteractionEnabled = false
    }

    @objc private func handleTapEmoji(_ sender: UIButton) {
        guard let emojiString = sender.titleLabel?.text else { return }
        sender.animateTapReceiving()
        value += emojiString
    }

    @objc private func handlePressCancel() {
        sendActions(for: .editingDidEndOnExit)
        dismiss()
    }

    @objc private func handlePressSubmit() {
        sendActions(for: .editingDidEnd)
        dismiss()
    }

    @objc private func handleInputChange() {
        value = inputContainer.field.text ?? ""
    }
}

// MARK: - Keyboard handling
extension EventInputView {
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        animateShowingKeyboard(notification: notification)
    }

    @objc func handleKeyboardWillHide(notification: NSNotification) {
        animateHidingKeyboard(notification: notification)
    }

    func animateShowingKeyboard(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }
        print(#function)
        let heightAboveKeyboard = inputContainer.background.bounds.height + emojiContainer.bounds.height + 2 * .buttonMargin
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        let newConstant = -keyboardHeight - heightAboveKeyboard

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve,
            animations: {
                self.constraint.constant = newConstant
                self.background.alpha = 1
                self.layoutIfNeeded()
            }
        )

        animator.addCompletion { _ in
            self.animationCompletionHandler?()
        }

        animator.startAnimation()
    }

    func animateHidingKeyboard(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }
        print(#function)
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve,
            animations: {
                self.constraint.constant = 0
                self.background.alpha = 0
                self.layoutIfNeeded()
            }
        )

        animator.addCompletion { _ in
            self.animationCompletionHandler?()
        }

        animator.startAnimation()
    }
}

// MARK: - Dark mode
extension EventInputView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        inputContainer.background.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
    }
}

// MARK: - UITextFieldDelegate
extension EventInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlePressSubmit()
        return true
    }
}
