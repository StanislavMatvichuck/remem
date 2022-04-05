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
}

class UIMovableTextView: UIControl, UIMovableTextViewInterface {
    //

    // MARK: - Public properties

    //

    var value: String {
        get { input.text }
        set { input.text = newValue }
    }

    var onboardingHighlight: UIView { viewInput.subviews[0] }

    //

    // MARK: - Private properties

    //

    private let viewInputBackground: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        return view
    }()

    private let viewInput: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = .r2
        view.isOpaque = true

        let input = UITextView(al: true)
        input.font = .systemFont(ofSize: .font1)
        input.textAlignment = .center
        input.backgroundColor = .clear

        view.addSubview(input)

        let circle = UIView(al: true)
        circle.layer.cornerRadius = .r1
        circle.backgroundColor = .tertiarySystemBackground

        view.addSubview(circle)

        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: .font1)
        label.numberOfLines = 1
        label.textColor = .systemBlue
        label.text = "0"

        view.addSubview(label)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .wScreen - 2 * .delta1),
            view.heightAnchor.constraint(equalToConstant: .d2),

            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.heightAnchor.constraint(equalToConstant: .d1),
            input.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * .d2),

            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .delta1),
            circle.widthAnchor.constraint(equalToConstant: .d1),
            circle.heightAnchor.constraint(equalToConstant: .d1),

            label.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -.r2),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()

    private var input: UITextView {
        viewInput.subviews[0] as! UITextView
    }

    private lazy var inputAnimatedConstraint: NSLayoutConstraint = {
        let constraint = viewInput.topAnchor.constraint(equalTo: bottomAnchor)
        return constraint
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        configureInputAccessoryView()
        setupView()
        setupEventHandlers()

        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //

    // MARK: - Internal behaviour

    //

    private func setupView() {
        addSubview(viewInputBackground)
        addSubview(viewInput)

        viewInputBackground.alpha = 0.0
        viewInputBackground.isHidden = true

        NSLayoutConstraint.activate([
            viewInput.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .xs),
            inputAnimatedConstraint,
        ])
    }

    private func setupEventHandlers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)

        viewInputBackground.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handlePressCancel)))
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

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.inputAnimatedConstraint.constant = -keyboardSize.cgRectValue.size.height - .d2 - .delta1
            self.viewInputBackground.alpha = 1
            self.layoutIfNeeded()
        }).startAnimation()
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

        animator.addCompletion { _ in
            self.viewInputBackground.isHidden = true
        }

        animator.startAnimation()
    }

    private func configureInputAccessoryView() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))

        let icon01 = UIBarButtonItem(title: "☕️", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon02 = UIBarButtonItem(title: "💊", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon03 = UIBarButtonItem(title: "👟", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon04 = UIBarButtonItem(title: "📖", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon05 = UIBarButtonItem(title: "🚬", style: .plain, target: self, action: #selector(handleEmojiPress))

        let spaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let dismiss = UIBarButtonItem(title: "Cancel",
                                      style: .plain,
                                      target: self,
                                      action: #selector(handlePressCancel))

        let create = UIBarButtonItem(title: "Add",
                                     style: .plain,
                                     target: self,
                                     action: #selector(handlePressCreate))

        bar.items = [
            dismiss,
            spaceLeft,
            icon01,
            icon02,
            icon03,
            icon04,
            icon05,
            spaceRight,
            create,
        ]

        bar.sizeToFit()

        input.inputAccessoryView = bar
    }

    @objc
    private func handleEmojiPress(_ barItem: UIBarButtonItem) {
        input.text += barItem.title!
    }

    @objc
    private func handlePressCancel() {
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
        value = ""
    }

    //

    // MARK: - Public behaviour

    //

    func show() {
        isUserInteractionEnabled = true
        input.becomeFirstResponder()
    }
}
