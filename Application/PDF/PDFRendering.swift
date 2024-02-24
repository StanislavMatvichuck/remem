//
//  PDFRendering.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.02.2024.
//

import UIKit

protocol PDFRendering: UIView {
    func configure(_: PdfRenderingPage)
    /// This method may mutate view.tag and use it for scrolling
    func scrollIfNeeded()
}

extension PDFRendering { func scrollIfNeeded() {}}

extension PDFWritingTitlePageView: PDFRendering {
    func configure(_ page: PdfRenderingPage) {
        guard let viewModel = page.viewModel as? String else { return }
        title.text = "Swipes recording report\n" + viewModel
    }
}

extension SummaryView: PDFRendering {
    func configure(_ page: PdfRenderingPage) {
        guard var viewModel = page.viewModel as? SummaryViewModel else { return }
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()

        let readableStart = formatter.string(from: viewModel.dateCreated)
        let readableEnd = formatter.string(from: .now)

        viewModel.items.insert(SummaryCellViewModel(.dateEnd, value: readableEnd), at: 0)
        viewModel.items.insert(SummaryCellViewModel(.dateStart, value: readableStart), at: 0)

        heightConstraint.isActive = false
        removeConstraint(heightConstraint)
        list.heightAnchor.constraint(equalToConstant: 6 * .layoutSquare + .buttonMargin).isActive = true
        self.viewModel = viewModel
        setNeedsLayout()
    }
}

extension HourDistributionView: PDFRendering {
    func configure(_ page: PdfRenderingPage) {
        guard let viewModel = page.viewModel as? HourDistributionViewModel else { return }
        self.viewModel = viewModel
    }
}

extension DayOfWeekView: PDFRendering {
    func configure(_ page: PdfRenderingPage) {
        guard let viewModel = page.viewModel as? DayOfWeekViewModel else { return }
        self.viewModel = viewModel
    }
}

extension WeekView: PDFRendering {
    func configure(_ page: PdfRenderingPage) {
        guard let viewModelWithIndex = page.viewModel as? WeekViewModelWithScrollIndex else { return }
        viewModel = viewModelWithIndex.viewModel
        tag = viewModelWithIndex.scrollIndex
    }

    func scrollIfNeeded() {
        let index = IndexPath(row: tag, section: 0)
        collection.scrollToItem(at: index, at: .right, animated: false)
    }
}
