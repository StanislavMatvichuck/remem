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
    func make() {}

    func make(
        dayCreated: DayIndex = .referenceValue,
        today: DayIndex = .referenceValue
    ) {
        createTemporaryLocalFileForReading(dateCreated: dayCreated.date, currentMoment: today.date)
        configureSut()
        putInViewHierarchy(sut)
    }

    var url: URLProviding { LocalFile.testingPdfReport }

    private func createTemporaryLocalFileForReading(dateCreated: Date, currentMoment: Date) {
        PdfMakingContainer(EventDetailsContainer(
            EventsListContainer(ApplicationContainer(mode: .injectedCurrentMoment, currentMoment: currentMoment)),
            event: Event(name: "Event", dateCreated: dateCreated)
        ), urlProviding: url).makePdfMakingViewModel().tapHandler()
    }

    private func configureSut() {
        let pdfContainer = PdfContainer(provider: url)

        sut = pdfContainer.make() as? PdfViewController
        sut.loadViewIfNeeded()
        sut.viewRoot.bounds = UIScreen.main.bounds
    }
}
