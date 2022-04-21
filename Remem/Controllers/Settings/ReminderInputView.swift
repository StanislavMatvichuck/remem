//
//  ReminderInput.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.04.2022.
//

import UIKit

class ReminderInputView: UIView {
    let titleInput: UITextField = {
        let input = UITextFieldWithPadding()
        let placeholderText = NSAttributedString(
            string: "Press here to add a reminder title",
            attributes: [
                NSAttributedString.Key.foregroundColor:
                    UIColor.label.withAlphaComponent(0.6),
            ]
        )
        input.font = .systemFont(ofSize: .font1)
        input.attributedPlaceholder = placeholderText
        input.clearButtonMode = .whileEditing
        input.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let accessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        let time = UIBarButtonItem(title: "Choose time", style: .done, target: nil, action: nil)
        accessory.items = [cancel, space, time]
        accessory.sizeToFit()

        input.inputAccessoryView = accessory

        return input
    }()

    let timeInput: UITextField = {
        let input = UITextFieldWithPadding()
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

        let accessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        let time = UIBarButtonItem(title: "Add reminder", style: .done, target: nil, action: nil)
        accessory.items = [cancel, space, time]
        accessory.sizeToFit()

        input.inputAccessoryView = accessory

        return input
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

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

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}
