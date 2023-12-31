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
        let container = EventDetailsContainer(EventsListContainer(ApplicationContainer(mode: .unitTest)), event: event)

        sut = SummaryContainer(parent: container).make() as? SummaryViewController
        sut.loadViewIfNeeded()
    }

    func assertLabelFor(
        summaryRow: SummaryRow,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let label = sut.viewRoot.viewWithTag(summaryRow.labelTag) as? UILabel
        XCTAssertEqual(label?.text, summaryRow.label, file: file, line: line)
    }

    func assertValueFor(
        summaryRow: SummaryRow,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let label = sut.viewRoot.viewWithTag(summaryRow.valueTag) as? UILabel
        XCTAssertEqual(label?.text, summaryRow.value, file: file, line: line)
    }
}
