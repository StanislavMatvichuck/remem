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

    var coordinator: Coordinator { parent.parent.parent.coordinator }
    var moment: Date { parent.parent.parent.currentMoment }
    var event: Event { parent.event }

    init(
        parent: EventDetailsContainer,
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
                titleVm: self.makePdfTitlePageViewModel()
            ).make()

            let saver = DefaultLocalFileSaver()
            saver.save(pdfData, to: self.urlProviding.url)

            let pdfContainer = PdfContainer(provider: self.urlProviding)
            self.coordinator.show(.pdf(factory: pdfContainer))
        }
    }

    func makePdfTitlePageViewModel() -> PdfTitlePageViewModel {
        PdfTitlePageViewModel(
            event: event,
            dateCreated: moment
        )
    }
}
