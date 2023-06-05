//
//  PdfMakingView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import UIKit

final class PdfMakingView: UIView {
    let button: UIButton = {
        let button = UIButton(al: true)

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.fontSmallBold,
            NSAttributedString.Key.foregroundColor: UIColor.bg,
        ]

        button.setAttributedTitle(
            NSAttributedString(
                string: String(localizationId: "pdf.create"),
                attributes: attributes
            ),
            for: .normal
        )

        button.backgroundColor = UIColor.primary
        button.layer.cornerRadius = (2 * .layoutSquare - 0.5 * .layoutSquare) / 2
        button.accessibilityIdentifier = UITestAccessibilityIdentifier.buttonPdfCreate.rawValue

        return button
    }()

    init() {
        super.init(frame: .zero)
        addSubview(button)
        let marginConstant: CGFloat = -0.5 * .layoutSquare
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 2 * .layoutSquare),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: marginConstant),
            button.heightAnchor.constraint(equalTo: heightAnchor, constant: marginConstant),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
