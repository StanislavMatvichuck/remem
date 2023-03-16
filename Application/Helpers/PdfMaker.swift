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

    let a4Width = 595.2
    let a4Height = 841.8
    var weekWidth: CGFloat { week.view.layer.bounds.width }
    var weekHeight: CGFloat { week.view.layer.bounds.height }
    var tileWidth: CGFloat { a4Width / 4 }
    var tileHeight: CGFloat { weekHeight * down }
    var down: CGFloat { tileWidth / weekWidth }
    var up: CGFloat { 1 / down }
    var weeksAmount: Int { week.viewModel.summaryTimeline.count - 1 }

    func make() -> Data {
        let a4Bounds = CGRect(x: 0, y: 0, width: a4Width, height: a4Height)
        let renderer = UIGraphicsPDFRenderer(bounds: a4Bounds)
        week.view.clipsToBounds = true

        return renderer.pdfData(actions: { context in
            context.beginPage()

            for i in 0 ..< weeksAmount {
                week.scrollToPrevious(weeksAmount - i)

                context.cgContext.scaleBy(x: down, y: down)
                week.view.layer.render(in: context.cgContext)
                context.cgContext.scaleBy(x: up, y: up)

                context.cgContext.translateBy(x: tileWidth, y: 0)
            }

//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)

            // second row
//            context.cgContext.translateBy(x: -3 * tileWidth, y: tileHeight)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)
//
//            context.cgContext.translateBy(x: tileWidth, y: 0)
//
//            context.cgContext.scaleBy(x: down, y: down)
//            week.view.layer.render(in: context.cgContext)
//            context.cgContext.scaleBy(x: up, y: up)

            context.beginPage()

            summary.view.layer.render(in: context.cgContext)
        })
    }
}
