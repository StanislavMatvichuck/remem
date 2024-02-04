//
//  TimeSinceView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class TimeSinceView: UIStackView {
    static let dotWidth = .buttonMargin / 3
    static let dotColor = UIColor.bg_item
    static let backgroundColor = UIColor.bg_secondary
    static let height = CGFloat.buttonMargin * 2

    let leftCorner: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = backgroundColor
        view.widthAnchor.constraint(equalToConstant: TimeSinceView.height / 2).isActive = true
        view.heightAnchor.constraint(equalToConstant: TimeSinceView.height / 2).isActive = true
        return view
    }()

    let rightCorner: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = backgroundColor
        view.widthAnchor.constraint(equalToConstant: TimeSinceView.height / 2).isActive = true
        view.heightAnchor.constraint(equalToConstant: TimeSinceView.height / 2).isActive = true
        return view
    }()

    let label: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .fontSmall
        label.textColor = UIColor.bg
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(_ vm: String) { label.text = vm }

    // MARK: - Private
    private func configureLayout() {
        alignment = .center
        addSubview(leftCorner)
        addSubview(rightCorner)
        addArrangedSubview(Self.makeDot())
        addArrangedSubview(label)
        addArrangedSubview(Self.makeDot())

        NSLayoutConstraint.activate([
            leftCorner.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftCorner.leadingAnchor.constraint(equalTo: leadingAnchor),

            rightCorner.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightCorner.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = Self.backgroundColor
        layer.cornerRadius = .buttonMargin
    }

    private static func makeDot() -> UIView {
        let container = UIView(al: true)
        container.widthAnchor.constraint(equalToConstant: Self.height).isActive = true
        container.heightAnchor.constraint(equalToConstant: Self.height).isActive = true

        let view = UIView(al: true)
        view.backgroundColor = dotColor
        view.layer.cornerRadius = dotWidth / 2
        view.widthAnchor.constraint(equalToConstant: Self.dotWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: Self.dotWidth).isActive = true

        container.addSubview(view)
        view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        return container
    }
}
