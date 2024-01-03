//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import Domain
import UIKit

final class PdfMakingContainer: ControllerFactoring, PdfMakingViewModelFactoring {
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
        PdfMakingViewController(self)
    }

    func makePdfMakingViewModel() -> PdfMakingViewModel {
        PdfMakingViewModel {
            let pdfData = MobilePdfMaker(
                viewModel: self.makePdfViewModel()
            ).make()

            let saver = DefaultLocalFileSaver()
            saver.save(pdfData, to: self.urlProviding.url)

            let pdfContainer = PdfContainer(provider: self.urlProviding)
            self.coordinator.show(.pdf(factory: pdfContainer))
        }
    }

    func makePdfViewModel() -> PdfViewModel {
        PdfViewModel(
            event: event,
            dateCreated: moment,
            clockViewModelDay: ClockContainer(parent: parent, type: .day).makeClockViewModel(),
            clockViewModelNight: ClockContainer(parent: parent, type: .night).makeClockViewModel(),
            summaryViewModel: SummaryContainer(parent: parent).makeSummaryViewModel(),
            weekViewModel: WeekContainer(parent).makeWeekViewModel()
        )
    }
}
