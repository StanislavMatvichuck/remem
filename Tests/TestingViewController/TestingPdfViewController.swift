//
//  TestingPdfMakingViewController.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 16.03.2023.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == PdfViewController {
    func make() {
        make(
            dayCreated: .referenceValue,
            today: .referenceValue
        )
    }

    func make(
        dayCreated: DayIndex = .referenceValue,
        today: DayIndex = .referenceValue
    ) {
        event = Event(name: "Event", dateCreated: dayCreated.date)

        let container = EventDetailsContainer(
            EventsListContainer(ApplicationContainer(mode: .unitTest)),
            event: event
        )

        let url = LocalFile.testingPdfReport

        let pdfMakingContainer = PdfMakingContainer(parent: container)

        let pdfMaker = pdfMakingContainer.make() as! PdfMakingViewController
        pdfMaker.loadViewIfNeeded()
        tap(pdfMaker.viewRoot.button)

        let pdfContainer = PdfContainer(provider: url)
        sut = pdfContainer.make() as? PdfViewController
        sut.loadViewIfNeeded()
        sut.viewRoot.bounds = UIScreen.main.bounds
        putInViewHierarchy(sut)
    }

    private func layout(_ vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.view.bounds = CGRect(
            origin: .zero,
            size: CGSize(
                width: 7 * .layoutSquare,
                height: 7 * .layoutSquare
            )
        )
        vc.view.layoutIfNeeded()
    }
}
