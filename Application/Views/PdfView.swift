//
//  PdfView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import PDFKit

final class PdfView: PDFView {
    init(_ url: URL) {
        super.init(frame: .zero)
        displayDirection = .vertical
        autoScales = true
        document = PDFDocument(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
