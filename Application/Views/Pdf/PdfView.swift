//
//  PdfView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import PDFKit

final class PdfView: UIView {
    private let url: URL
    private var pdf: PDFView?

    init(_ url: URL) {
        self.url = url
        super.init(frame: .zero)
    }

    override func didMoveToSuperview() {
        let document = PDFDocument(url: url)
        let pdf = PDFKit.PDFView(frame: bounds)
        pdf.displayDirection = .vertical
        pdf.autoScales = true
        pdf.document = document
        addSubview(pdf)
        self.pdf = pdf
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    /// Used by tests only
    func scrollTo(page number: Int) {
        guard
            let pdf,
            let document = pdf.document,
            let page = document.page(at: number)
        else { return }

        let firstPageBounds = page.bounds(for: pdf.displayBox)
        let rect = CGRect(x: 0, y: firstPageBounds.height, width: 1.0, height: 1.0)

        pdf.go(to: rect, on: page)
    }
}
