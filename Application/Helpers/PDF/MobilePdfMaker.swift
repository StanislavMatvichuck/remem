//
//  MobilePdfMaker.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.05.2023.
//

import Foundation
import UIKit

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
        placeClockTile(context, viewModel: viewModel.clockViewModelDay)

        makeNewPage(context)
        placeClockTile(context, viewModel: viewModel.clockViewModelNight)

        makeNewPage(context)
        placeQRTile(context)

        for i in 0 ..< viewModel.weekViewModel.pages.count {
            makeNewPage(context)
            placeWeekTile(tileNumber: i, context)
        }
    }

    private func placeFirstTile(_ context: UIGraphicsPDFRendererContext) {
        let view = PdfTitlePageView()
        view.frame = page
        view.configure(viewModel)
        view.layoutIfNeeded()

        view.layer.render(in: context.cgContext)
    }

    private func placeClockTile(_ context: UIGraphicsPDFRendererContext, viewModel: ClockViewModel) {
        let clock = ClockView(viewModel: viewModel)
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
        var viewModel = viewModel.weekViewModel
        viewModel.timelineVisibleIndex = i * 7
        let week = WeekView(viewModel)
        week.translatesAutoresizingMaskIntoConstraints = true
        week.frame = page
        week.layoutIfNeeded()

        week.layer.render(in: context.cgContext)
    }

    private func placeQRTile(_ context: UIGraphicsPDFRendererContext) {
        let qr = PdfQRPageView()
        let view = UIView(frame: page)

        view.addSubview(qr)
        qr.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        qr.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qr.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.layoutIfNeeded()
        view.layer.render(in: context.cgContext)
    }

    private func lastTile(_ i: Int) -> Bool { i == viewModel.weekViewModel.pages.count }

    private func makeNewPage(_ context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        context.cgContext.setFillColor(UIColor.bg.cgColor)
        context.cgContext.fill(page)
    }
}
