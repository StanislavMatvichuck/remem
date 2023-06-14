//
//  PdfView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import PDFKit

final class PdfView: UIView {
    let url: URL

    init(_ url: URL) {
        self.url = url
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func didMoveToSuperview() {
        let document = PDFDocument(url: url)
        let pdfView = PDFKit.PDFView(frame: bounds)
        pdfView.displayDirection = .vertical
        pdfView.document = document
        addSubview(pdfView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
