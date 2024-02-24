//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import DataLayer
import Domain
import UIKit

final class PDFWritingContainer: ControllerFactoring, PDFWritingViewModelFactoring {
    let parent: EventDetailsContainer
    let urlProviding: URLProviding

    var coordinator: Coordinator { parent.parent.coordinator }
    var moment: Date { parent.parent.currentMoment }
    var event: Event { parent.event }

    init(
        _ parent: EventDetailsContainer,
        urlProviding: URLProviding = LocalFile.pdfReport
    ) {
        self.parent = parent
        self.urlProviding = urlProviding
    }

    func make() -> UIViewController {
        PDFWritingViewController(self)
    }

    func makePdfMakingViewModel() -> PDFWritingViewModel {
        PDFWritingViewModel {
            let weekViewModel = WeekContainer(self.parent).makeWeekViewModel()
            var pages: [PdfRenderingPage] = [
                .title(self.event.name),
                .summary(SummaryContainer(parent: self.parent).makeSummaryViewModel()),
                .time(HourDistributionContainer(self.parent).makeHourDistributionViewModel()),
                .week(DayOfWeekContainer(self.parent).makeDayOfWeekViewModel())
            ]

            for index in 0 ..< weekViewModel.pagesCount {
                pages.append(.weekInYear(
                    WeekViewModelWithScrollIndex(
                        viewModel: weekViewModel,
                        scrollIndex: index
                    ))
                )
            }

            let pdfData = PDFDataGenerator(pages: pages).make()

            let saver = DefaultLocalFileSaver()
            saver.save(pdfData, to: self.urlProviding.url)

            let pdfContainer = PDFReadingContainer(provider: self.urlProviding)
            self.coordinator.show(.pdf(factory: pdfContainer))
        }
    }

    func makePdfViewModel() -> PDFReadingViewModel {
        PDFReadingViewModel(
            event: event,
            dateCreated: moment,
            clockViewModelDay: ClockContainer(parent: parent, type: .day).makeClockViewModel(),
            clockViewModelNight: ClockContainer(parent: parent, type: .night).makeClockViewModel(),
            summaryViewModel: SummaryContainer(parent: parent).makeSummaryViewModel(),
            weekViewModel: WeekContainer(parent).makeWeekViewModel()
        )
    }
}
