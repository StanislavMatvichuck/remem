//
//  StatsViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

@testable import Application
import Domain
import XCTest

final class SummaryViewControllerTests: XCTestCase, TestingViewController {
    var sut: SummaryViewController!
    var event: Event!
    var commander: EventsCommanding!

    override func setUp() {
        super.setUp()
        make()
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_showsTotalHappenings() {
        assertLabelFor(summaryRow: SummaryRow.total(value: ""), file: #file, line: #line)
    }

    func test_showsWeekAverage() {
        assertLabelFor(summaryRow: SummaryRow.weekAverage(value: ""), file: #file, line: #line)
    }

    func test_showsDayAverageHappenings() {
        assertLabelFor(summaryRow: SummaryRow.dayAverage(value: ""))
    }

    func test_showsDaysTracked() {
        assertLabelFor(summaryRow: SummaryRow.daysTracked(value: ""))
    }

    func test_showsDaysSinceLastHappening() {
        assertLabelFor(summaryRow: SummaryRow.daysSinceLastHappening(value: ""))
    }

    func test_newEvent_showsTotalHappeningsAmount_zero() {
        assertValueFor(summaryRow: SummaryRow.total(value: "0"), file: #file, line: #line)
    }

    func test_newEvent_showsWeekAverageAmount_zero() {
        assertValueFor(summaryRow: SummaryRow.weekAverage(value: "0"), file: #file, line: #line)
    }

    func test_newEvent_showsDayAverageAmount_zero() {
        assertValueFor(summaryRow: SummaryRow.dayAverage(value: "0"))
    }

    func test_newEvent_showsDaysTrackedAmount_one() {
        assertValueFor(summaryRow: SummaryRow.daysTracked(value: "1"))
    }

    func test_newEvent_showsDaysSinceLastHappening_zero() {
        assertValueFor(summaryRow: SummaryRow.daysSinceLastHappening(value: "0"))
    }
}
