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

class EventInput: UIControl {
    // MARK: - Properties
    var value: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    var animationCompletionHandler: (() -> Void)?

    /// Layout
    let textField: UITextField = {
        let input = UITextField(al: true)
        input.font = .font
        input.textAlignment = .center
        input.backgroundColor = .clear
        input.adjustsFontSizeToFitWidth = true
        input.minimumFontSize = UIFont.fontSmall.pointSize
        input.returnKeyType = .done
        return input
    }()

    let background: UIView = {
        let view = UIView(al: true)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        view.isHidden = true
        view.backgroundColor = .clear
        view.addAndConstrain(blurView)
        return view
    }()

    let viewInput: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .bg_item
        view.layer.cornerRadius = .buttonRadius
        view.layer.borderColor = UIColor.border.cgColor
        view.layer.borderWidth = .border
        view.isOpaque = true
        view.layer.shadowRadius = 30
        view.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
        view.layer.shadowOpacity = 1
        return view
    }()

    let hint: UILabel = {
        let label = UILabel(al: true)
        label.text = String(localizationId: "eventsList.new")
        label.textAlignment = .center
        label.font = .fontBold
        label.textColor = UIColor.secondary
        label.numberOfLines = 0
        return label
    }()

    let emojiContainer: UIScrollView = {
        let scroll = ViewScroll(.horizontal, spacing: .buttonMargin)
        scroll.viewContent.layoutMargins = UIEdgeInsets(
            top: 0, left: .buttonMargin,
            bottom: 0, right: .buttonMargin
        )
        scroll.viewContent.isLayoutMarginsRelativeArrangement = true
        scroll.showsHorizontalScrollIndicator = false

        for emoji in ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"] {
            let button = UIButton(al: true)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = .fontBoldBig
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7).isActive = true
            scroll.contain(views: button)
        }

        return scroll
    }()

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
}

// MARK: - Public
extension EventInput: EventInputing {
    func show(value: String) {
        self.value = value
        background.isHidden = false
        background.alpha = 0.0
        isUserInteractionEnabled = true
        textField.becomeFirstResponder()

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
extension EventInput {
    private func setupLayout() {
        background.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.widthAnchor.constraint(equalTo: background.readableContentGuide.widthAnchor),
            hint.centerXAnchor.constraint(equalTo: background.readableContentGuide.centerXAnchor),
            hint.topAnchor.constraint(equalTo: background.safeAreaLayoutGuide.topAnchor, constant: .buttonMargin),
        ])

        addAndConstrain(background)

        viewInput.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: viewInput.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: viewInput.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: .buttonHeight),
            textField.widthAnchor.constraint(equalTo: viewInput.widthAnchor, constant: -2 * .buttonHeight),
        ])

        addSubview(viewInput)
        NSLayoutConstraint.activate([
            viewInput.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .buttonMargin),
            viewInput.heightAnchor.constraint(equalToConstant: .buttonHeight),
            viewInput.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        addSubview(emojiContainer)
        NSLayoutConstraint.activate([
            emojiContainer.widthAnchor.constraint(equalTo: widthAnchor),
            emojiContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiContainer.bottomAnchor.constraint(equalTo: viewInput.topAnchor, constant: -.buttonMargin),
        ])

        NSLayoutConstraint.activate([constraint])
    }

    // Events handlers
    private func setupEventHandlers() {
        textField.delegate = self

        background.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handlePressCancel)
            )
        )

        textField.addTarget(
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

    private func dismiss() {
        value = ""
        textField.resignFirstResponder()
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
        value = textField.text ?? ""
    }
}

// MARK: - Keyboard handling
extension EventInput {
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

        let heightAboveKeyboard = viewInput.bounds.height + emojiContainer.bounds.height + 2 * .buttonMargin
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
extension EventInput {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewInput.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
    }
}

// MARK: - UITextFieldDelegate
extension EventInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlePressSubmit()
        return true
    }
}
