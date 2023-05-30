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
    private let clock: ClockViewController
    private let titlePageViewModel: PdfTitlePageViewModel

    let pageWidth = CGFloat.screenW * 0.94
    var tileWidth: CGFloat { pageWidth / 2 }
    var tileHeight: CGFloat { tileWidth }

    var pageHeight: CGFloat { tileHeight * 2 + 1 }
    var page: CGRect { CGRect(origin: .zero, size: CGSize(width: pageWidth, height: pageHeight)) }
    var weekWidth: CGFloat { week.view.layer.bounds.width }

    var down: CGFloat { tileWidth / weekWidth }
    var up: CGFloat { 1 / down }
    var weeksAmount: Int { week.viewModel.pages.count }
    var gridColumns: Int { 2 }
    var height: CGFloat = 0

    init(
        week: WeekViewController,
        summary: SummaryViewController,
        clock: ClockViewController,
        titleVm: PdfTitlePageViewModel
    ) {
        self.week = week
        self.summary = summary
        self.clock = clock
        self.titlePageViewModel = titleVm
    }

    func make() -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: page)
        let data = renderer.pdfData(actions: { context in
            renderControllersInGrid(context)
        })
        return data
    }

    private func renderControllersInGrid(_ context: UIGraphicsPDFRendererContext) {
        makeNewPage(context)

        placeFirstTile(context)
        moveToNextTile(context)

        placeSummaryTile(context)
        moveToNextTile(context)
        moveToNextLine(context)

        placeClockTile(context)
        moveToNextTile(context)

        makeNewPage(context)

        for i in 0 ..< weeksAmount {
            if nextLineNeeded(i) { moveToNextLine(context) }
            if nextPageNeeded(i) { makeNewPage(context) }

            placeWeekTile(tileNumber: i, context)
            moveToNextTile(context)
        }
    }

    private func placeFirstTile(_ context: UIGraphicsPDFRendererContext) {
        let view = PdfTitlePageView()
        view.frame = CGRect(origin: .zero, size: CGSize(width: weekWidth, height: weekWidth))
        view.configure(titlePageViewModel)
        view.layoutIfNeeded()

        context.cgContext.scaleBy(x: down, y: down)
        view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)
    }

    private func placeClockTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.scaleBy(x: down, y: down)
        clock.view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)
    }

    private func placeSummaryTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.scaleBy(x: down, y: down)
        summary.view.layer.render(in: context.cgContext)
        context.cgContext.scaleBy(x: up, y: up)
    }

    private func placeWeekTile(tileNumber i: Int, _ context: UIGraphicsPDFRendererContext) {
        week.viewModel.timelineVisibleIndex = i * 7
        week.viewRoot.setNeedsLayout()
        week.viewRoot.layoutIfNeeded()

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
        context.cgContext.setFillColor(UIColor.bg.cgColor)
        context.cgContext.fill(page)
        height = tileHeight
    }

    private func moveToNextTile(_ context: UIGraphicsPDFRendererContext) {
        context.cgContext.translateBy(x: tileWidth, y: 0)
    }
}
