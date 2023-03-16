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
        let day = DayIndex.referenceValue
        event = Event(name: "Event", dateCreated: day.date)

        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)

        let week = container.makeWeekViewController()
        layout(week)

        let summary = container.makeSummaryViewController()
        layout(summary)

        let url = LocalFile.testingPdfReport

        let pdfMakingContainer = PdfMakingContainer(
            week: week,
            summary: summary,
            coordinator: container.parent.parent.coordinator,
            urlProviding: url
        )

        let pdfMaker = pdfMakingContainer.make() as! PdfMakingViewController
        pdfMaker.loadViewIfNeeded()
        tap(pdfMaker.viewRoot.button)

        let pdfContainer = PdfContainer(provider: url)
        sut = pdfContainer.make() as? PdfViewController
        sut.loadViewIfNeeded()
        putInViewHierarchy(sut)
    }

    private func layout(_ vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.view.bounds = UIScreen.main.bounds
        vc.view.layoutIfNeeded()
    }
}
