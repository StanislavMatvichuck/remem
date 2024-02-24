//
//  PdfTitlePageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 30.05.2023.
//

import UIKit

final class PDFWritingTitlePageView: UIView {
    let title: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() { addAndConstrain(title, constant: .buttonMargin) }

    private func configureAppearance() {
        title.font = .fontBoldBig
        title.textColor = .secondary
    }
}
