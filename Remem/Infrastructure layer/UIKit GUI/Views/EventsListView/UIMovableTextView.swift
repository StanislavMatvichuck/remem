//
//  UIMovableTextView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.04.2022.
//

import UIKit

protocol UIMovableTextViewInterface: UIControl {
    var value: String { get }

    func show(value: String)
    func rename(oldName: String)
    func dismiss()
}

class UIMovableTextView: UIControl {
    // MARK: I18n
    static let empty = NSLocalizedString("empty.EventsList.firstName", comment: "Events list empty state")
    static let cancel = NSLocalizedString("button.cancel", comment: "movable view accessory button cancel")
    static let add = NSLocalizedString("button.add.event", comment: "movable view accessory button add")

    // MARK: - Properties
    var value: String = "" {
        didSet {
            input.text = value
            barSubmit.isEnabled = !value.isEmpty
        }
    }

    private lazy var barCancel = UIBarButtonItem(
        title: Self.cancel,
        style: .plain,
        target: self,
        action: #selector(handlePressCancel))

    private lazy var barSubmit = UIBarButtonItem(
        title: Self.add,
        style: .done,
        target: self,
        action: #selector(handlePressSubmit))

    private var input: UITextField { viewInput.subviews[0] as! UITextField }
    private lazy var inputAnimatedConstraint: NSLayoutConstraint = {
        let constraint = viewInput.topAnchor.constraint(equalTo: bottomAnchor)
        return constraint
    }()

    let viewInputBackground: UIView = {
        let view = UIView(al: true)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
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

        let input = UITextField(al: true)
        input.font = UIHelper.font
        input.textAlignment = .center
        input.backgroundColor = .clear
        input.adjustsFontSizeToFitWidth = true
        input.minimumFontSize = .font1
        view.addSubview(input)

        NSLayoutConstraint.activate([
            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.heightAnchor.constraint(equalToConstant: .d2),
            input.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * .d2),
        ])

        return view
    }()

    private lazy var namingHintLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.empty
        label.textAlignment = .center
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
        label.numberOfLines = 0

        viewInputBackground.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            label.centerXAnchor.constraint(equalTo: readableContentGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        ])

        return label
    }()

    private lazy var emojiContainer: UIScrollView = {
        let scroll = ViewScroll(.horizontal, spacing: .sm)
        scroll.viewContent.layoutMargins = UIEdgeInsets(top: 0, left: .sm, bottom: 0, right: .sm)
        scroll.viewContent.isLayoutMarginsRelativeArrangement = true
        scroll.showsHorizontalScrollIndicator = false

        for emoji in [
            "📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭",
        ] {
            let label = UILabel(al: true)
            label.text = emoji
            label.font = .systemFont(ofSize: 48)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapEmoji)))
            scroll.contain(views: label)
        }

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.widthAnchor.constraint(equalTo: widthAnchor),
            scroll.centerXAnchor.constraint(equalTo: centerXAnchor),
            scroll.bottomAnchor.constraint(equalTo: viewInput.topAnchor, constant: -.sm),
        ])

        return scroll
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setupLayoutAndVisibility()
        setupInputAccessoryView()
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { NotificationCenter.default.removeObserver(self) }
}

// MARK: - Public
extension UIMovableTextView: UIMovableTextViewInterface {
    func show(value: String) {
        self.value = value
        isUserInteractionEnabled = true
        input.becomeFirstResponder()
    }

    func rename(oldName: String) {
        show(value: oldName)
        barSubmit.title = "Rename"
    }

    func dismiss() { handlePressCancel() }
}

// MARK: - Private
extension UIMovableTextView {
    private func setupLayoutAndVisibility() {
        addAndConstrain(viewInputBackground)

        addSubview(viewInput)
        NSLayoutConstraint.activate([
            viewInput.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .sm),
            viewInput.heightAnchor.constraint(equalToConstant: .d2),
            viewInput.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        viewInputBackground.isHidden = true
        viewInput.isHidden = false
        namingHintLabel.isHidden = false
        emojiContainer.isHidden = true

        isUserInteractionEnabled = false

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

        barSubmit.isEnabled = !value.isEmpty

        bar.items = [barCancel, space, barSubmit]
        bar.sizeToFit()

        input.inputAccessoryView = bar
    }

    // Events handlers
    private func setupEventHandlers() {
        input.delegate = self

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)

        viewInputBackground.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handlePressCancel)))

        input.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
    }

    @objc private func handleTapEmoji(_ sender: UITapGestureRecognizer) {
        if
            let label = sender.view as? UILabel,
            let emoji = label.text
        {
            value += emoji
        }
    }

    @objc private
    func handlePressCancel() {
        sendActions(for: .editingDidEndOnExit)
        hideInput()
    }

    @objc private
    func handlePressSubmit() {
        sendActions(for: .editingDidEnd)
        hideInput()
    }

    @objc private
    func handleInputChange() {
        value = input.text ?? ""
    }

    private
    func hideInput() {
        input.resignFirstResponder()

        isUserInteractionEnabled = false
        value = ""
        barSubmit.title = Self.add
    }
}

// MARK: - Keyboard handling
extension UIMovableTextView {
    @objc private
    func handleKeyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }

        viewInputBackground.isHidden = false
        emojiContainer.isHidden = false

        let newConstant = -keyboardSize.cgRectValue.size.height - .d2 - .sm

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = newConstant
            self.viewInputBackground.alpha = 1
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

        viewInputBackground.isHidden = true
        emojiContainer.isHidden = true

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = 0
            self.viewInputBackground.alpha = 0
            self.layoutIfNeeded()
        }).startAnimation()
    }
}

// MARK: - Dark mode
extension UIMovableTextView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewInput.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
    }
}

// MARK: - UITextFieldDelegate
extension UIMovableTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlePressSubmit()
        return true
    }
}
