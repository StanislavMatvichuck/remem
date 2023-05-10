//
//  MobilePdfMaker.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.05.2023.
//

import Foundation
import UIKit

// TODO: remove duplications in pdf makers
final class MobilePdfMaker: PDFMaking {
    private let week: WeekViewController
    private let summary: SummaryViewController

    let pageWidth = CGFloat.screenW * 0.94
    var pageHeight: CGFloat { tileHeight * 2 + 1 }
    var weekWidth: CGFloat { week.view.layer.bounds.width }
    var weekHeight: CGFloat { week.view.layer.bounds.height }
    var tileWidth: CGFloat { pageWidth / 2 }
    var tileHeight: CGFloat { weekHeight * down }
    var down: CGFloat { tileWidth / weekWidth }
    var up: CGFloat { 1 / down }
    var weeksAmount: Int { week.viewModel.pages.count }
    var gridColumns: Int { 2 }
    var height: CGFloat = 0

    init(week: WeekViewController, summary: SummaryViewController) {
        self.week = week
        self.summary = summary
    }

    func make() -> Data {
        let a4Bounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: a4Bounds)

        return renderer.pdfData(actions: { context in
            context.beginPage()
            height = tileHeight
            renderControllersInGrid(context)
        })
    }

    private func renderControllersInGrid(_ context: UIGraphicsPDFRendererContext) {
        for i in 0 ... weeksAmount {
            if nextLineNeeded(i) { moveToNextLine(context) }
            if nextPageNeeded(i) { makeNewPage(context) }

            if lastTile(i) {
                placeSummaryTile(context)
            } else {
                placeWeekTile(tileNumber: i, context)
            }

            moveToNextTile(context)
        }
    }

    private func placeSummaryTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.scaleBy(x: down, y: down)
        summary.view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)
    }

    private func placeWeekTile(tileNumber i: Int, _ context: UIGraphicsPDFRendererContext) {
        week.scrollTo(i * 7)

        context.cgContext.scaleBy(x: down, y: down)
        week.view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)
    }

    private func nextLineNeeded(_ i: Int) -> Bool { i > 0 && i % gridColumns == 0 }
    private func nextPageNeeded(_ i: Int) -> Bool { height >= pageHeight }
    private func lastTile(_ i: Int) -> Bool { i == weeksAmount }

    private func moveToNextLine(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.translateBy(x: -CGFloat(gridColumns) * tileWidth, y: tileHeight)
        height += tileHeight
    }

    private func makeNewPage(_ context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        height = tileHeight
    }

    private func moveToNextTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.translateBy(x: tileWidth, y: 0)
    }
}
