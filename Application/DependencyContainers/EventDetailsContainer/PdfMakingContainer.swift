//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import UIKit

final class PdfMakingContainer: ControllerFactoring {
    let week: WeekViewController
    let summary: SummaryViewController
    let coordinator: Coordinator

    init(
        week: WeekViewController,
        summary: SummaryViewController,
        coordinator: Coordinator
    ) {
        self.week = week
        self.summary = summary
        self.coordinator = coordinator
    }

    func make() -> UIViewController {
        let controller = PdfMakingViewController(
            provider: LocalFile.pdfReport,
            pdfMaker: DefaultPdfMaker(week: week, summary: summary),
            saver: DefaultLocalFileSaver(),
            completion: {
                self.coordinator.show(.pdf(
                    factory: PdfContainer(provider: LocalFile.pdfReport)
                ))
            }
        )
        return controller
    }
}
