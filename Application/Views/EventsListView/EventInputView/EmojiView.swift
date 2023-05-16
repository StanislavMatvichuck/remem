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
        viewContent.layoutMargins = UIEdgeInsets(
            top: 0, left: .buttonMargin,
            bottom: 0, right: .buttonMargin
        )

        viewContent.isLayoutMarginsRelativeArrangement = true
        showsHorizontalScrollIndicator = false

        for emoji in ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"] {
            let button = UIButton(al: true)
            button.setTitle(emoji, for: .normal)
            button.accessibilityIdentifier = emoji
            button.isAccessibilityElement = true
            button.titleLabel?.font = .fontBoldBig
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7).isActive = true
            contain(views: button)
        }
    }

    private func configureAppearance() {}
}
