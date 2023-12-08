//
//  PdfQRPageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.06.2023.
//

import UIKit

final class PdfQRPageView: UIView {
    let stack: UIStackView = {
        let image = UIImage(named: "qr")?.withTintColor(.secondary)
        let imageView = UIImageView(al: true)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill

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
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        imageView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5).isActive = true
        label.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.9).isActive = true

        return stack
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addAndConstrain(stack)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
