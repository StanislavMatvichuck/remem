//
//  DayControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class DayDetailsViewControllerTests: XCTestCase, TestingViewController {
    var sut: DayDetailsViewController!
    var event: Event!
    var commander: EventsCommanding!

    override func setUp() {
        super.setUp()
        make()
    }

    override func tearDown() {
        super.tearDown()
        clear()
    }

    func test_tableIsConfigured() {
        XCTAssertNotNil(sut.viewRoot.happeningsCollection.dataSource)
        XCTAssertNotNil(sut.viewRoot.happeningsCollection.delegate)
    }

    func test_showsTitle() {
        let numberString = sut.viewRoot.title.text!.split(separator: " ").first
        let wordString = sut.viewRoot.title.text!.split(separator: " ").last

        XCTAssertNotNil(Int(numberString!))
        XCTAssertLessThanOrEqual(3, wordString!.count)
    }

    func test_showsCreateHappeningButton() {
        XCTAssertEqual(sut.viewRoot.button.text, String(localizationId: "button.addHappening"))
    }

    func test_empty_noHappeningsInList() {
        XCTAssertEqual(happeningsAmount, 0)
    }

    func test_singleHappening_showsTime() {
        addHappening(at: DayIndex.referenceValue.date)
        sendEventUpdatesToController()

        assertCellHasTimeText(at: firstIndex)
    }

    // TODO: finish
    func test_singleHappening_hasSwipeToDelete() {}

    // TODO: finish
    func test_singleHappening_swipedToDelete_removesHappeningFromList() {}

    func test_manyHappenings_showsManyHappenings() {
        let date = DayIndex.referenceValue.date
        addHappening(at: date.addingTimeInterval(1))
        addHappening(at: date.addingTimeInterval(2))
        addHappening(at: date.addingTimeInterval(3))
        sendEventUpdatesToController()

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: firstIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
    }

    private func assertCellHasTimeText(
        at index: IndexPath,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let cell = happening(at: index)
        XCTAssertNotNil(cell.label.text?.firstIndex(of: ":"), file: file, line: line)
        XCTAssertLessThanOrEqual(5, cell.label.text?.count ?? 0, file: file, line: line)
    }
}
