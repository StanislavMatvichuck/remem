//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsView: UIView {
    //

    // MARK: - Public properties

    //
    //

    // MARK: - Private properties

    //

    let viewWatchOnboarding: UIView = {
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
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
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
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

        return container
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)

        updateBackgroundColors()

        setupLabelOnboarding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabelOnboarding() {
        addSubview(viewWatchOnboarding)

        NSLayoutConstraint.activate([
            viewWatchOnboarding.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .delta1),
            viewWatchOnboarding.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .delta1),
            viewWatchOnboarding.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),
        ])
    }

    //

    // MARK: - Events handling

    //

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateBackgroundColors()
    }

    private func updateBackgroundColors() {
        layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        viewWatchOnboarding.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
    }
}
