//
//  PdfMaker.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import Foundation
import UIKit

final class DefaultPdfMaker: PDFMaking {
    private let week: WeekViewController
    private let summary: SummaryViewController

    let a4Width = 595.2
    let a4Height = 841.8
    var weekWidth: CGFloat { week.view.layer.bounds.width }
    var weekHeight: CGFloat { week.view.layer.bounds.height }
    var tileWidth: CGFloat { a4Width / 4 }
    var tileHeight: CGFloat { weekHeight * down }
    var down: CGFloat { tileWidth / weekWidth }
    var up: CGFloat { 1 / down }
    var weeksAmount: Int { week.viewModel.pages.count }
    var height: CGFloat = 0

    init(week: WeekViewController, summary: SummaryViewController) {
        self.week = week
        self.summary = summary
    }

    func make() -> Data {
        let a4Bounds = CGRect(x: 0, y: 0, width: a4Width, height: a4Height)
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

        prepareWeekForPdfRendering()

        context.cgContext.scaleBy(x: down, y: down)
        week.view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)

        prepareWeekForUIKitRendering()
    }

    private func nextLineNeeded(_ i: Int) -> Bool { i > 0 && i % 4 == 0 }
    private func nextPageNeeded(_ i: Int) -> Bool { height >= a4Height }
    private func lastTile(_ i: Int) -> Bool { i == weeksAmount }

    private func moveToNextLine(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.translateBy(x: -4 * tileWidth, y: tileHeight)
        height += tileHeight
    }

    private func makeNewPage(_ context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        height = 0
    }

    private func moveToNextTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.translateBy(x: tileWidth, y: 0)
    }

    private func prepareWeekForPdfRendering() {
        executeForAllWeekVisibleCells { cell in
            cell.view.layer.mask = nil
            cell.view.pdfMode = true
        }
    }

    private func prepareWeekForUIKitRendering() {
        executeForAllWeekVisibleCells { cell in
            cell.view.pdfMode = false
        }
    }

    private func executeForAllWeekVisibleCells(closure: (WeekCell) -> Void) {
        for row in 0 ..< week.viewRoot.collection.numberOfItems(inSection: 0) {
            let indexPath = NSIndexPath(row: row, section: 0)

            guard let cell = week.viewRoot.collection.cellForItem(at: indexPath as IndexPath) as? WeekCell else { continue }

            closure(cell)
        }
    }
}
