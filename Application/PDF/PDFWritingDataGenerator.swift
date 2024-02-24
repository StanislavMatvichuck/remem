//
//  MobilePdfMaker.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.05.2023.
//

import Foundation
import UIKit

struct PDFDataGenerator {
    private let pages: [PdfRenderingPage]

    init(pages: [PdfRenderingPage]) { self.pages = pages }

    func make() -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: PdfRenderingPage.size)
        let data = renderer.pdfData(actions: { context in
            render(context)
        })
        return data
    }

    // MARK: - Private
    private func render(_ context: UIGraphicsPDFRendererContext) {
        for page in pages {
            makeNewPage(context)

            let pageView = UIView(frame: PdfRenderingPage.size)
            let renderer = page.renderer
            renderer.translatesAutoresizingMaskIntoConstraints = false
            renderer.configure(page)
            pageView.addSubview(renderer)
            renderer.centerXAnchor.constraint(equalTo: pageView.centerXAnchor).isActive = true
            renderer.widthAnchor.constraint(equalTo: pageView.widthAnchor).isActive = true
            renderer.centerYAnchor.constraint(equalTo: pageView.centerYAnchor).isActive = true

            if let text = page.title {
                let title = UILabel(al: true)
                title.font = .font
                title.textColor = .secondary
                title.text = text
                pageView.addSubview(title)
                title.centerXAnchor.constraint(equalTo: pageView.centerXAnchor).isActive = true
                title.widthAnchor.constraint(equalTo: pageView.widthAnchor, constant: -2 * .buttonMargin).isActive = true
                title.bottomAnchor.constraint(equalTo: renderer.topAnchor).isActive = true
            }

            pageView.layoutIfNeeded()
            renderer.scrollIfNeeded()

            pageView.layer.render(in: context.cgContext)
        }
    }

    private func makeNewPage(_ context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        context.cgContext.setFillColor(UIColor.bg.cgColor)
        context.cgContext.fill(PdfRenderingPage.size)
    }
}
