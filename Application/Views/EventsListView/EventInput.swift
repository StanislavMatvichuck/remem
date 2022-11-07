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
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
            barSubmit.isEnabled = !value.isEmpty
        }
    }

    let barCancel = UIBarButtonItem(
        title: String(localizationId: "button.cancel"),
        style: .plain, target: nil, action: nil)

    let barSubmit = UIBarButtonItem(
        title: String(localizationId: "button.create"),
        style: .done, target: nil, action: nil)

    let textField: UITextField = {
        let input = UITextField(al: true)
        input.font = UIHelper.font
        input.textAlignment = .center
        input.backgroundColor = .clear
        input.adjustsFontSizeToFitWidth = true
        input.minimumFontSize = .font1
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
        view.backgroundColor = UIHelper.background
        view.layer.cornerRadius = .r2
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
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
        label.numberOfLines = 0
        return label
    }()

    let emojiContainer: UIScrollView = {
        let scroll = ViewScroll(.horizontal, spacing: .sm)
        scroll.viewContent.layoutMargins = UIEdgeInsets(top: 0, left: .sm, bottom: 0, right: .sm)
        scroll.viewContent.isLayoutMarginsRelativeArrangement = true
        scroll.showsHorizontalScrollIndicator = false

        for emoji in ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"] {
            let button = UIButton(al: true)
            button.setTitle(emoji, for: .normal)
            scroll.contain(views: button)
        }

        return scroll
    }()

    private lazy var inputAnimatedConstraint: NSLayoutConstraint = {
        let constraint = emojiContainer.topAnchor.constraint(equalTo: bottomAnchor)
        return constraint
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false

        setupLayout()
        setupInputAccessoryView()
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { NotificationCenter.default.removeObserver(self) }
}

// MARK: - Public
extension EventInput: EventInputing {
    func show(value: String = "") {
        self.value = value
        background.isHidden = false
        background.alpha = 0.0
        isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }

    func rename(oldName: String) {
        show(value: oldName)
        barSubmit.title = String(localizationId: "button.rename")
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
            hint.topAnchor.constraint(equalTo: background.safeAreaLayoutGuide.topAnchor, constant: UIHelper.spacing),
        ])

        addAndConstrain(background)

        viewInput.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: viewInput.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: viewInput.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: .d2),
            textField.widthAnchor.constraint(equalTo: viewInput.widthAnchor, constant: -2 * .d2),
        ])

        addSubview(viewInput)
        NSLayoutConstraint.activate([
            viewInput.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .sm),
            viewInput.heightAnchor.constraint(equalToConstant: .d2),
            viewInput.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        addSubview(emojiContainer)
        NSLayoutConstraint.activate([
            emojiContainer.widthAnchor.constraint(equalTo: widthAnchor),
            emojiContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiContainer.bottomAnchor.constraint(equalTo: viewInput.topAnchor, constant: -.sm),
        ])

        NSLayoutConstraint.activate([inputAnimatedConstraint])
    }

    private func setupInputAccessoryView() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        barSubmit.setTitleTextAttributes([.font: UIHelper.font], for: .normal)
        barSubmit.setTitleTextAttributes([.font: UIHelper.font], for: .disabled)
        barSubmit.setTitleTextAttributes([.font: UIHelper.font], for: .selected)

        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .normal)
        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .disabled)
        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .selected)

        bar.items = [barCancel, space, barSubmit]
        bar.sizeToFit()

        textField.inputAccessoryView = bar
    }

    // Events handlers
    private func setupEventHandlers() {
        textField.delegate = self

        background.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handlePressCancel))
        )

        textField.addTarget(
            self,
            action: #selector(handleInputChange),
            for: .editingChanged)

        setupToolbarButtons()
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
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    private func setupToolbarButtons() {
        barCancel.target = self
        barCancel.action = #selector(handlePressCancel)

        barSubmit.target = self
        barSubmit.action = #selector(handlePressSubmit)
    }

    @objc private func handleTapEmoji(_ sender: UIButton) {
        guard let emojiString = sender.titleLabel?.text else { return }

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

    private func dismiss() {
        value = ""
//        background.isHidden = true
        textField.resignFirstResponder()
        isUserInteractionEnabled = false
        barSubmit.title = String(localizationId: "button.create")
    }
}

// MARK: - Keyboard handling
extension EventInput {
    @objc private
    func handleKeyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }

        let emojiContainerHeight = emojiContainer.bounds.height
        let viewInputHeight = viewInput.bounds.height
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        let newConstant = -keyboardHeight - emojiContainerHeight - viewInputHeight

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = newConstant
            self.background.alpha = 1
            self.layoutIfNeeded()
        }).startAnimation()
    }

    @objc private
    func handleKeyboardWillHide(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = 0
            self.background.alpha = 0
            self.layoutIfNeeded()
        }).startAnimation()
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
