//
//  PdfQRPageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.06.2023.
//

import UIKit

final class PdfQRPageView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        let width = UIScreen.main.bounds.width / 2

        let image = UIImage(named: "qr")?.withTintColor(.secondary)
        let view = UIImageView(al: true)
        view.image = image
        view.contentMode = .scaleAspectFit

        let label = UILabel(al: true)
        label.font = .fontBold
        label.textColor = .text
        label.text = String(localizationId: "pdf.download")
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.33

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(view)
        stack.addArrangedSubview(label)

        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: width).isActive = true
        label.widthAnchor.constraint(equalToConstant: width * 2).isActive = true

        addAndConstrain(stack)
    }
}
