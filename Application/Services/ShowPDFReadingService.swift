//
//  ShowPDFReadingService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2024.
//

import DataLayer
import Domain
import Foundation

protocol PDFReadingControllerFactoring {
    func makePDFReadingController(url: URL) -> PDFReadingViewController
}

protocol PDFViewModelFactoring { func makePDFViewModel() -> [PdfRenderingPage] }

struct ShowPDFReadingService: ApplicationService {
    private let coordinator: Coordinator
    private let controllerFactory: PDFReadingControllerFactoring
    private let viewModelFactory: PDFViewModelFactoring
    private let eventsProvider: EventsQuerying

    init(
        coordinator: Coordinator,
        controllerFactory: PDFReadingControllerFactoring,
        viewModelFactory: PDFViewModelFactoring,
        eventsProvider: EventsQuerying
    ) {
        self.coordinator = coordinator
        self.controllerFactory = controllerFactory
        self.viewModelFactory = viewModelFactory
        self.eventsProvider = eventsProvider
    }

    func serve(_: ApplicationServiceEmptyArgument) {
        let pages = self.viewModelFactory.makePDFViewModel()

        // pdfViewModel used to make Data
        let pdfData = PDFDataGenerator(pages: pages).make()

        let url = LocalFile.pdfReport.url
        // Data saved to local file
        let saver = DefaultLocalFileSaver()
        saver.save(pdfData, to: url)

        // navigating to reader with url for local file
        self.coordinator.goto(
            navigation: .pdfReading,
            controller: self.controllerFactory.makePDFReadingController(url: url)
        )
    }
}
