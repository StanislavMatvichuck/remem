//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsView: UIView {
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

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        updateBackgroundColors()
//        setupLabelOnboarding()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

//    private func setupLabelOnboarding() {
//        addSubview(viewWatchOnboarding)
//    }

    // MARK: - Dark mode handling
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundColors()
    }

    private func updateBackgroundColors() {
        layer.backgroundColor = UIColor.systemBackground.cgColor
        viewWatchOnboarding.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}
