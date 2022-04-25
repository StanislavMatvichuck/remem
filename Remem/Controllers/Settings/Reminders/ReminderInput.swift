//
//  ReminderInput.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.04.2022.
//

import UIKit

class ReminderInput: UIControl {
    // MARK: I18n
    static let titleCancel = NSLocalizedString("button.cancel", comment: "UIReminderInput cancel title")
    static let titleSubmit = NSLocalizedString("button.reminder.submit.title", comment: "UIReminderInput submit title")
    static let timeCancel = NSLocalizedString("button.reminder.cancel.time", comment: "UIReminderInput cancel time")
    static let timeSubmit = NSLocalizedString("button.reminder.submit.time", comment: "UIReminderInput submit time")
    static let placeholderTitle = NSLocalizedString("placeholder.inputReminder.title", comment: "UIReminderInput title placeholder")

    // MARK: - Type props
    typealias ValueTuple = (title: String?, hour: Int?, minute: Int?)

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Properties
    var value: ValueTuple {
        let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
        return (title: titleInput.text, hour: components.hour, minute: components.minute)
    }

    private lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    // MARK: - View props
    private lazy var titleCancel = UIBarButtonItem(
        title: Self.titleCancel, style: .plain,
        target: self, action: #selector(handlePressCancel)
    )
    private lazy var titleSubmit = UIBarButtonItem(
        title: Self.titleSubmit, style: .done,
        target: self, action: #selector(handleTitleSubmit)
    )
    private lazy var timeCancel = UIBarButtonItem(
        title: Self.timeCancel, style: .plain,
        target: self, action: #selector(handlePressCancel)
    )
    private lazy var timeSubmit = UIBarButtonItem(
        title: Self.timeSubmit, style: .done,
        target: self, action: #selector(handleTimeSubmit)
    )

    private lazy var titleInput: UITextField = {
        let input = UITextFieldWithPadding()
        let placeholderText = NSAttributedString(
            string: Self.placeholderTitle,
            attributes: [
                NSAttributedString.Key.foregroundColor:
                    UIColor.label.withAlphaComponent(0.6),
            ]
        )
        input.font = .systemFont(ofSize: .font1)
        input.attributedPlaceholder = placeholderText
        input.clearButtonMode = .whileEditing
        input.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        input.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let accessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessory.items = [titleCancel, space, titleSubmit]
        accessory.sizeToFit()

        input.inputAccessoryView = accessory

        return input
    }()

    private lazy var timeInput: UITextField = {
        let input = UITextFieldWithPadding()
        // TODO: format this string
        let placeholderText = NSAttributedString(
            string: "00:00",
            attributes: [
                NSAttributedString.Key.foregroundColor:
                    UIColor.label.withAlphaComponent(0.6),
            ]
        )
        input.font = .systemFont(ofSize: .font1)
        input.attributedPlaceholder = placeholderText
        input.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        input.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let accessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessory.items = [timeCancel, space, timeSubmit]
        accessory.sizeToFit()

        input.inputAccessoryView = accessory

        return input
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        timeInput.inputView = picker
        titleInput.returnKeyType = .next

        setupLayout()
        setupEventHandlers()
        updateAccessoryButtons()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    private func setupLayout() {
        layer.cornerRadius = .delta1

        addSubview(titleInput)
        addSubview(timeInput)

        NSLayoutConstraint.activate([
            titleInput.topAnchor.constraint(equalTo: topAnchor),
            titleInput.bottomAnchor.constraint(equalTo: bottomAnchor),

            timeInput.topAnchor.constraint(equalTo: topAnchor),
            timeInput.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleInput.trailingAnchor.constraint(equalTo: timeInput.leadingAnchor),
            timeInput.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Dark mode
extension ReminderInput {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIColor.systemBackground.cgColor
    }
}

// MARK: - Private
extension ReminderInput {
    private func reset() {
        endEditing(false)
        timeInput.text = ""
        titleInput.text = ""
        updateAccessoryButtons()
    }

    @objc private func updateAccessoryButtons() {
        let titleEmpty = titleInput.text?.isEmpty ?? true
        let timeEmpty = timeInput.text?.isEmpty ?? true

        titleSubmit.isEnabled = !titleEmpty
        timeSubmit.isEnabled = !titleEmpty && !timeEmpty
    }
}

// MARK: - User input
extension ReminderInput {
    private func setupEventHandlers() {
        titleInput.delegate = self
        picker.addTarget(self, action: #selector(handlePicker), for: .valueChanged)
        titleInput.addTarget(self, action: #selector(updateAccessoryButtons), for: .editingChanged)
        timeInput.addTarget(self, action: #selector(updateAccessoryButtons), for: .editingChanged)
    }

    @objc func handlePressCancel(_ sender: UITextField) {
        if sender == titleCancel { reset() }
        if sender == timeCancel { titleInput.becomeFirstResponder() }
    }

    @objc func handleTitleSubmit() { timeInput.becomeFirstResponder() }
    @objc func handleTimeSubmit() {
        sendActions(for: .editingDidEnd)
        reset()
    }

    @objc func handlePicker(_ sender: UIDatePicker) {
        timeInput.text = ReminderInput.formatter.string(from: picker.date)
        updateAccessoryButtons()
    }
}

// MARK: - UITextFieldDelegate
extension ReminderInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleInput { handleTitleSubmit() }

        return true
    }
}
