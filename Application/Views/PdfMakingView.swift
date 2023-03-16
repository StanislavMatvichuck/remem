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
            NSAttributedString.Key.font: UIHelper.fontSmallBold,
            NSAttributedString.Key.foregroundColor: UIHelper.colorButtonTextHighLighted,
        ]

        button.setAttributedTitle(
            NSAttributedString(
                string: "Create pdf",
                attributes: attributes
            ),
            for: .normal
        )

        button.backgroundColor = UIHelper.brand
        button.layer.cornerRadius = UIHelper.r2
        button.heightAnchor.constraint(equalToConstant: UIHelper.d2).isActive = true

        return button
    }()

    init() {
        super.init(frame: .zero)

        addAndConstrain(
            button,
            left: UIHelper.spacingListHorizontal,
            right: UIHelper.spacingListHorizontal,
            bottom: UIHelper.height
        )
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
