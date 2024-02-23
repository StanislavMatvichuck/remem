//
//  StatsViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

@testable import Application
import Domain
import XCTest

final class SummaryViewControllerTests: XCTestCase {
    private var sut: SummaryViewController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        let eventDetails = EventDetailsContainer(appC, event: event)
        let container = SummaryContainer(parent: eventDetails)
        sut = SummaryViewController(container)
        let view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(sut.view)
        sut.view.layoutIfNeeded()
    }

    override func tearDown() { super.tearDown(); clear() }

    // MARK: - Tests

    func test_showsTotal_zero() { XCTAssertEqual(sut.totalValue, "0") }
    func test_showsDaysTracked_one() { XCTAssertEqual(sut.daysTracked, "1") }
    func test_showsDayAverage_zero() { XCTAssertEqual(sut.dayAverage, "0") }
    func test_showsWeekAverage_zero() { XCTAssertEqual(sut.weekAverage, "0") }

    // MARK: - Private
    private func clear() { sut = nil }
}

private extension SummaryViewController {
    var totalValue: String? { cellValueAt(row: 0) }
    var daysTracked: String? { cellValueAt(row: 1) }
    var dayAverage: String? { cellValueAt(row: 2) }
    var weekAverage: String? { cellValueAt(row: 3) }
    private func cellValueAt(row: Int) -> String? {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = viewRoot.list.dataSource?.collectionView(viewRoot.list, cellForItemAt: indexPath)
        return (cell as? SummaryCell)?.value.text
    }
}
