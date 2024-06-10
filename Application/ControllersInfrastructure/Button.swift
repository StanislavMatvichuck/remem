//
//  Button.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import UIKit

class Button: UIButton {
    private let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    private func configureLayout() {
        heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight).isActive = true
        layer.cornerRadius = .buttonRadius
    }

    private func configureAppearance() {
        backgroundColor = UIColor.bg_item
        layer.borderColor = UIColor.remem_primary.cgColor
        layer.borderWidth = .border

        setAttributedTitle(NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont.font,
                NSAttributedString.Key.foregroundColor: UIColor.remem_primary,
            ]
        ), for: .normal)
    }
}
