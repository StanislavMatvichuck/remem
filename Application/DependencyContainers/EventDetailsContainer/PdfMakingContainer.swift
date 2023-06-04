//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import Domain
import UIKit

final class PdfMakingContainer: ControllerFactoring {
    let urlProviding: URLProviding
    let event: Event
    let currentMoment: Date
    let week: WeekViewController
    let summary: SummaryViewController
    let clock: ClockViewController
    let coordinator: Coordinator?

    init(
        event: Event,
        currentMoment: Date,
        week: WeekViewController,
        summary: SummaryViewController,
        clock: ClockViewController,
        coordinator: Coordinator? = nil,
        urlProviding: URLProviding = LocalFile.pdfReport
    ) {
        self.event = event
        self.currentMoment = currentMoment
        self.week = week
        self.summary = summary
        self.clock = clock
        self.coordinator = coordinator
        self.urlProviding = urlProviding
    }

    func make() -> UIViewController {
        let pdfMaker = MobilePdfMaker(
            week: week,
            summary: summary,
            clock: clock,
            titleVm: makePdfTitlePageViewModel()
        )
        let controller = PdfMakingViewController(
            provider: urlProviding,
            pdfMaker: pdfMaker,
            saver: DefaultLocalFileSaver(),
            completion: {
                self.coordinator?.show(.pdf(
                    factory: PdfContainer(provider: self.urlProviding)
                ))
            }
        )
        return controller
    }

    func makePdfTitlePageViewModel() -> PdfTitlePageViewModel {
        PdfTitlePageViewModel(event: event, dateCreated: currentMoment)
    }
}
