//
//  EmojiView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.05.2023.
//

import UIKit

final class EmojiView: ViewScroll {
    init() {
        super.init(.horizontal, spacing: .buttonMargin)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        configureMargins()

        for emoji in ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"] {
            contain(views: makeButton(emoji))
        }
    }

    private func configureAppearance() {
        showsHorizontalScrollIndicator = false
    }

    private func configureMargins() {
        viewContent.isLayoutMarginsRelativeArrangement = true
        viewContent.layoutMargins = UIEdgeInsets(
            top: 0, left: .buttonMargin,
            bottom: 0, right: .buttonMargin
        )
    }

    private func makeButton(_ text: String) -> UIButton {
        let button = UIButton(al: true)
        button.setTitle(text, for: .normal)
        button.accessibilityIdentifier = text
        button.isAccessibilityElement = true
        button.titleLabel?.font = .fontBoldBig
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
        return button
    }
}
