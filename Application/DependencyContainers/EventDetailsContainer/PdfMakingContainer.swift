//
//  PdfContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

import UIKit

final class PdfMakingContainer: ControllerFactoring {
    let urlProviding: URLProviding
    let week: WeekViewController
    let summary: SummaryViewController
    let coordinator: Coordinator?

    init(
        week: WeekViewController,
        summary: SummaryViewController,
        coordinator: Coordinator? = nil,
        urlProviding: URLProviding = LocalFile.pdfReport
    ) {
        self.week = week
        self.summary = summary
        self.coordinator = coordinator
        self.urlProviding = urlProviding
    }

    func make() -> UIViewController {
        let controller = PdfMakingViewController(
            provider: urlProviding,
            pdfMaker: DefaultPdfMaker(week: week, summary: summary),
            saver: DefaultLocalFileSaver(),
            completion: {
                self.coordinator?.show(.pdf(
                    factory: PdfContainer(provider: self.urlProviding)
                ))
            }
        )
        return controller
    }
}
