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
    private static let pageWidth = CGFloat.screenW * 0.94

    private let page = CGRect(
        origin: .zero,
        size: CGSize(
            width: pageWidth,
            height: pageWidth
        )
    )

    private let viewModel: PdfViewModel

    init(viewModel: PdfViewModel) {
        self.viewModel = viewModel
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
        makeNewPage(context)

        placeSummaryTile(context)
        makeNewPage(context)

        placeClockTile(context)
        makeNewPage(context)

        placeQRTile(context)
        makeNewPage(context)

        for i in 0 ..< viewModel.weeksAmount {
            placeWeekTile(tileNumber: i, context)
            makeNewPage(context)
        }
    }

    private func placeFirstTile(_ context: UIGraphicsPDFRendererContext) {
        let view = PdfTitlePageView()
        view.frame = page
        view.configure(viewModel)
        view.layoutIfNeeded()

        view.layer.render(in: context.cgContext)
    }

    private func placeClockTile(_ context: UIGraphicsPDFRendererContext) {
        let clock = ClockView(viewModel: viewModel.clockViewModel)
        let view = UIView(frame: page)

        view.addSubview(clock)
        clock.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        clock.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        clock.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.layoutIfNeeded()
        view.layer.render(in: context.cgContext)
    }

    private func placeSummaryTile(_ context: UIGraphicsPDFRendererContext) {
        let summary = SummaryView(viewModel: viewModel.summaryViewModel)
        let view = UIView(frame: page)
        
        view.addSubview(summary)
        summary.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        summary.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        summary.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.layoutIfNeeded()
        view.layer.render(in: context.cgContext)
    }

    private func placeWeekTile(tileNumber i: Int, _ context: UIGraphicsPDFRendererContext) {
//        week.viewModel.timelineVisibleIndex = i * 7
//        week.viewRoot.setNeedsLayout()
//        week.viewRoot.layoutIfNeeded()
//
//        context.cgContext.scaleBy(x: down, y: down)
//        week.view.layer.render(in: context.cgContext)
//        context.cgContext.scaleBy(x: up, y: up)
    }

    private func placeQRTile(_ context: UIGraphicsPDFRendererContext) {
        let view = PdfQRPageView()
        view.frame = page
        view.layoutIfNeeded()

        view.layer.render(in: context.cgContext)
    }

    private func lastTile(_ i: Int) -> Bool { i == viewModel.weeksAmount }

    private func makeNewPage(_ context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        context.cgContext.setFillColor(UIColor.bg.cgColor)
        context.cgContext.fill(page)
    }
}
