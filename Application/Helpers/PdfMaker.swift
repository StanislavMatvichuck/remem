//
//  PdfMaker.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import Foundation
import UIKit

protocol PDFMaking {
    func make() -> Data
}

final class DefaultPdfMaker: PDFMaking {
    private let week: WeekViewController
    private let summary: SummaryViewController

    init(week: WeekViewController, summary: SummaryViewController) {
        self.week = week
        self.summary = summary
    }

    func make() -> Data {
        let a4PageSize = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: a4PageSize)
        week.view.clipsToBounds = true

        return renderer.pdfData(actions: { context in
            context.beginPage()

            week.view.layer.render(in: context.cgContext)

            context.beginPage()

            summary.view.layer.render(in: context.cgContext)
        })
    }
}
