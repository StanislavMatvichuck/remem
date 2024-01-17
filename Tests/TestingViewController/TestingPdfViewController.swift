//
//  TestingPDFWritingViewController.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 16.03.2023.
//

@testable import Application
import Domain
import XCTest
import DataLayer

extension TestingViewController where Controller == PDFReadingViewController {
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
        PDFWritingContainer(
            EventDetailsContainer(ApplicationContainer(
                mode: .injectedCurrentMoment,
                currentMoment: currentMoment
            ),
            event: Event(name: "Event", dateCreated: dateCreated)),
            urlProviding: url
        ).makePdfMakingViewModel().tapHandler()
    }

    private func configureSut() {
        let pdfContainer = PDFReadingContainer(provider: url)

        sut = pdfContainer.make() as? PDFReadingViewController
        sut.loadViewIfNeeded()
        sut.viewRoot.bounds = UIScreen.main.bounds
    }
}
