//
//  TestingSummaryViewController.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == SummaryViewController {
    func make() {
        event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: DayIndex.referenceValue)
        sut = container.makeSummaryViewController()
        commander = container.weekViewModelUpdater
        sut.loadViewIfNeeded()
    }

    func assertLabelFor(
        summaryRow: SummaryViewModel.SummaryRow,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let label = sut.viewRoot.viewWithTag(summaryRow.labelTag) as? UILabel
        XCTAssertEqual(label?.text, summaryRow.label, file: file, line: line)
    }

    func assertValueFor(
        summaryRow: SummaryViewModel.SummaryRow,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let label = sut.viewRoot.viewWithTag(summaryRow.valueTag) as? UILabel
        XCTAssertEqual(label?.text, summaryRow.value, file: file, line: line)
    }
}
