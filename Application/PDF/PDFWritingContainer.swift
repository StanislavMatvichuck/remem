//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import DataLayer
import Domain
import UIKit

final class PDFWritingContainer:
    PDFWritingViewModelFactoring,
    PDFViewModelFactoring
{
    let parent: EventDetailsContainer

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController { PDFWritingViewController(self, service: makeShowPDFReadingService()) }
    func makePdfMakingViewModel() -> PDFWritingViewModel { PDFWritingViewModel() }
    func makeShowPDFReadingService() -> ShowPDFReadingService { ShowPDFReadingService(
        coordinator: parent.parent.coordinator,
        controllerFactory: PDFReadingContainer(),
        viewModelFactory: self,
        eventsProvider: parent.parent.provider
    ) }

    func makePDFViewModel() -> [PdfRenderingPage] {
        let weekViewModel = WeekContainer(parent).makeWeekViewModel()
        var pages: [PdfRenderingPage] = [
            .title(parent.event.name),
            .summary(SummaryContainer(parent).makeSummaryViewModel()),
            .time(HourDistributionContainer(parent).makeHourDistributionViewModel()),
            .week(DayOfWeekContainer(parent).makeDayOfWeekViewModel())
        ]

        for index in 0 ..< weekViewModel.pagesCount {
            pages.append(.weekInYear(
                WeekViewModelWithScrollIndex(
                    viewModel: weekViewModel,
                    scrollIndex: index
                ))
            )
        }

        return pages
    }
}
