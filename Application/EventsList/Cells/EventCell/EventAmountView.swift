//
//  EventAmountView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class EventAmountView: UIView {
    let label = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .font
        label.textColor = UIColor.text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.accessibilityIdentifier = UITestAccessibilityIdentifier.eventCellValue.rawValue
        label.isAccessibilityElement = true
        return label
    }()

    let background: UIView = {
        let view = UIView(al: true)
        view.widthAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        view.heightAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(_ vm: EventCellViewModel) {
        label.text = vm.value
    }

    // MARK: - Private
    private func configureLayout() {
        background.addAndConstrain(label)
        addSubview(background)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .buttonHeight),
            heightAnchor.constraint(equalToConstant: .buttonHeight),
            background.centerXAnchor.constraint(equalTo: centerXAnchor),
            background.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func configureAppearance() {
        background.backgroundColor = .bg
        background.layer.cornerRadius = .swiperRadius
        background.layer.borderColor = UIColor.border.cgColor
        background.layer.borderWidth = .border
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }
}
