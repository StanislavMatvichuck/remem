//
//  UIMovableTextView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.04.2022.
//

import UIKit

protocol UIMovableTextViewInterface: UIControl {
    var onboardingHighlight: UIView { get }
    var value: String { get set }

    func show()
    func disableCancelButton()
    func enableCancelButton()
}

class UIMovableTextView: UIControl, UIMovableTextViewInterface {
    typealias KeyboardHeightChangeDescriptor = (movedBy: CGPoint, duration: Double)

    // MARK: I18n
    static let empty = NSLocalizedString("empty.EventsList.firstName", comment: "Events list empty state")
    static let cancel = NSLocalizedString("button.cancel", comment: "movable view accessory button cancel")
    static let add = NSLocalizedString("button.add.event", comment: "movable view accessory button add")

    // MARK: - Properties
    var value: String = "" { didSet { barAdd.isEnabled = !value.isEmpty } }
    var onboardingHighlight: UIView { viewInput }

    private var input: UITextField { viewInput.subviews[0] as! UITextField }

    lazy var viewInputBackground: UIView = {
        let view = UIView(al: true)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addAndConstrain(blurView)
        addAndConstrain(view)
        return view
    }()

    private lazy var viewInput: UIView = {
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

        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .sm),
            view.heightAnchor.constraint(equalToConstant: .d2),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),

            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.heightAnchor.constraint(equalToConstant: .d2),
            input.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * .d2),
        ])

        return view
    }()

    private lazy var inputAnimatedConstraint: NSLayoutConstraint = {
        let constraint = viewInput.topAnchor.constraint(equalTo: bottomAnchor)
        return constraint
    }()

    private lazy var barCancel = UIBarButtonItem(
        title: Self.cancel,
        style: .plain,
        target: self,
        action: #selector(handlePressCancel))

    private lazy var barAdd = UIBarButtonItem(
        title: Self.add,
        style: .done,
        target: self,
        action: #selector(handlePressCreate))

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
            label.heightAnchor.constraint(equalToConstant: .hScreen / 3),
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

        setupView()
        configureInputAccessoryView()
        setupEventHandlers()

        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    deinit { NotificationCenter.default.removeObserver(self) }

    private func setupView() {
        viewInputBackground.isHidden = true
        viewInput.isHidden = false
        namingHintLabel.isHidden = false
        emojiContainer.isHidden = true

        NSLayoutConstraint.activate([inputAnimatedConstraint])
    }
}

// MARK: - Public
extension UIMovableTextView {
    func show() {
        isUserInteractionEnabled = true
        input.becomeFirstResponder()
    }

    func disableCancelButton() {
        barCancel.isEnabled = false
    }

    func enableCancelButton() {
        barCancel.isEnabled = true
    }
}

// MARK: - Private
extension UIMovableTextView {
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

        input.addTarget(self, action: #selector(textViewDidChange), for: .editingChanged)
    }

    @objc
    private func handleKeyboardWillShow(notification: NSNotification) {
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

        postWillShowNotification(newConstant: newConstant, duration: duration)

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = newConstant
            self.viewInputBackground.alpha = 1
            self.layoutIfNeeded()
        })

        animator.addCompletion { _ in
            NotificationCenter.default.post(name: .UIMovableTextViewShown, object: self.viewInput)
        }

        animator.startAnimation()
    }

    private func postWillShowNotification(newConstant: CGFloat, duration: Double) {
        let existingConstant = inputAnimatedConstraint.constant
        let constantDifference = newConstant - existingConstant

        let notificationObject: KeyboardHeightChangeDescriptor = (
            movedBy: CGPoint(x: 0, y: constantDifference),
            duration: duration)

        NotificationCenter.default.post(name: .UIMovableTextViewWillShow, object: notificationObject)
    }

    @objc
    private func handleKeyboardWillHide(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveType = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveType)
        else { return }

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = 0
            self.viewInputBackground.alpha = 0
            self.layoutIfNeeded()
        })

        viewInputBackground.isHidden = true
        emojiContainer.isHidden = true

        animator.startAnimation()
    }

    private func configureInputAccessoryView() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        barAdd.setTitleTextAttributes([.font: UIHelper.font], for: .normal)
        barAdd.setTitleTextAttributes([.font: UIHelper.font], for: .disabled)
        barAdd.setTitleTextAttributes([.font: UIHelper.font], for: .selected)

        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .normal)
        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .disabled)
        barCancel.setTitleTextAttributes([.font: UIHelper.font], for: .selected)

        barAdd.isEnabled = !value.isEmpty

        bar.items = [barCancel, space, barAdd]
        bar.sizeToFit()

        input.inputAccessoryView = bar
    }

    @objc
    private func handleEmojiPress(_ barItem: UIBarButtonItem) {
        input.text? += barItem.title!
        textViewDidChange(input)
    }

    @objc private func handleTapEmoji(_ sender: UITapGestureRecognizer) {
        if
            let label = sender.view as? UILabel,
            let emoji = label.text
        {
            input.text? += emoji
            textViewDidChange(input)
        }
    }

    @objc
    private func handlePressCancel(_ sender: UITapGestureRecognizer) {
        sendActions(for: .editingDidEndOnExit)
        hideInput()
    }

    @objc
    private func handlePressCreate() {
        sendActions(for: .editingDidEnd)
        hideInput()
    }

    private func hideInput() {
        input.resignFirstResponder()

        isUserInteractionEnabled = false
        input.text = ""
        textViewDidChange(input)
    }

    @objc func textViewDidChange(_ textView: UITextField) {
        value = textView.text ?? ""
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let UIMovableTextViewShown = Notification.Name(rawValue: "UISwipingInputShown")
    static let UIMovableTextViewWillShow = Notification.Name(rawValue: "UIMovableTextViewWillShow")
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
        handlePressCreate()
        return true
    }
}
