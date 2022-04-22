//
//  SettingsRowView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.04.2022.
//

import UIKit

class SettingsRowView: UIView {
    init(_ text: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let label: UILabel = {
            let label = UILabel(al: true)
            label.text = text
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .label
            return label
        }()

        let chevron: UIImageView = {
            let image = UIImage(systemName: "chevron.right")?
                .withTintColor(.opaqueSeparator)
                .withRenderingMode(.alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: .font1)))

            let container = UIImageView(image: image)
            container.translatesAutoresizingMaskIntoConstraints = false

            return container
        }()


        addSubview(label)
        addSubview(chevron)

        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2 * .delta1),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2 * .delta1),
            label.trailingAnchor.constraint(equalTo: chevron.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2 * .delta1),

            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * .delta1),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
//        layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}
