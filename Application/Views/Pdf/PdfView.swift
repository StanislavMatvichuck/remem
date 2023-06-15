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
        let document = PDFDocument(url: url)
        let pdf = PDFView()
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.displayDirection = .vertical
        pdf.document = document
        addSubview(pdf)
        NSLayoutConstraint.activate([
            pdf.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pdf.leadingAnchor.constraint(equalTo: leadingAnchor),
            pdf.trailingAnchor.constraint(equalTo: trailingAnchor),
            pdf.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
