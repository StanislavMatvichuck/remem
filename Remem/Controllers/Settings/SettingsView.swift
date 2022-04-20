//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsView: UIView {
    static var margin: CGFloat = 2 * .delta1

    lazy var viewWatchOnboarding: UIView = {
        let label: UILabel = {
            let label = UILabel(al: true)
            label.text = "Watch onboarding"
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .label
            return label
        }()

        let chevron: UIImageView = {
            let image = UIImage(systemName: "chevron.right")?
                .withTintColor(.tertiaryLabel)
                .withRenderingMode(.alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: .font1)))

            let container = UIImageView(image: image)
            container.translatesAutoresizingMaskIntoConstraints = false

            return container
        }()

        let container: UIView = {
            let view = UIView(al: true)
            view.layer.cornerRadius = .delta1

            view.addSubview(label)
            view.addSubview(chevron)
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2 * .delta1),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2 * .delta1),
                label.trailingAnchor.constraint(equalTo: chevron.leadingAnchor),
                label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2 * .delta1),

                chevron.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                chevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2 * .delta1),
            ])

            return view
        }()

        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .sm),
            container.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
        ])

        return container
    }()

    private lazy var title: UILabel = {
        let label = UILabel(al: true)
        label.text = "Settings"
        label.textColor = .label
        label.font = .systemFont(ofSize: .font2, weight: .bold)

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sm),
            label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
        ])

        return label
    }()

    private lazy var reminderInput: UIView = {
        let container = UIView(al: true)
        container.layer.cornerRadius = .delta1

        let titleInput: UITextField = {
            let input = TextFieldWithPadding(al: true)
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
            let input = TextFieldWithPadding(al: true)
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

        container.addSubview(titleInput)
        container.addSubview(timeInput)
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: viewWatchOnboarding.bottomAnchor, constant: SettingsView.margin),
            container.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),

            titleInput.heightAnchor.constraint(equalTo: container.heightAnchor),
            timeInput.heightAnchor.constraint(equalTo: titleInput.heightAnchor),

            titleInput.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleInput.trailingAnchor.constraint(equalTo: timeInput.leadingAnchor),
            timeInput.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])

        return container
    }()

    private lazy var footer: UILabel = {
        let label = UILabel(al: true)
        label.textColor = .label
        label.font = .systemFont(ofSize: 0.6 * .font1)
        label.text = "Made with ❤️ in 🇺🇦"

        addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        return label
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        updateBackgroundColors()
        footer.tag = 1
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Dark mode handling
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundColors()
    }

    private func updateBackgroundColors() {
        layer.backgroundColor = UIColor.systemBackground.cgColor
        viewWatchOnboarding.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        reminderInput.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: SettingsView.margin,
        left: SettingsView.margin,
        bottom: SettingsView.margin,
        right: SettingsView.margin
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
