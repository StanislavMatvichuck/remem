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

// @MainActor
final class DayDetailsControllerTests: XCTestCase {
    var sut: DayDetailsController!
    var eventId: String!

    override func setUp() {
        super.setUp()
        let container = DayDetailsContainer.makeForUnitTests()
        eventId = container.parent.eventId
        sut = container.makeDayDetailsController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        eventId = nil
        sut = nil
    }

    func test_listIsConfigured() { XCTAssertNotNil(sut.viewRoot.happeningsCollection.dataSource) }

    func test_showsTitle() {
        let numberString = sut.viewRoot.title.text!.split(separator: " ").first
        let wordString = sut.viewRoot.title.text!.split(separator: " ").last

        XCTAssertNotNil(Int(numberString!))
        XCTAssertLessThanOrEqual(3, wordString!.count)
    }

    func test_showsCreateHappeningButton() { XCTAssertEqual(sut.viewRoot.button.text, String(localizationId: localizationIdButtonAddHappening)) }
    func test_empty_noHappeningsInList() { XCTAssertEqual(happeningsAmount, 0) }

    func test_singleHappening_showsTime() {
        addHappening(at: DayIndex.referenceValue.date)

        assertCellHasTimeText(at: firstCellIndex)
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

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: firstCellIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
    }

    func test_manyHappenings_allowsItemDrag() {
//        XCTAssert(sut is UICollectionViewDragDelegate)
        XCTAssertNotNil(sut.viewRoot.happeningsCollection.dragDelegate)
    }

    func test_manyHappenings_allowsDraggedItemsDrop() {
//        XCTAssert(sut is UIDropInteractionDelegate)
        XCTAssertNotEqual(sut.viewRoot.buttonBackground.interactions.count, 0, "interaction must be added to button to allow drop to delete")
    }

    let firstCellIndex = IndexPath(row: 0, section: 0)

    private func assertCellHasTimeText(
        at index: IndexPath,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let cell = happening(at: index)
        XCTAssertNotNil(cell.label.text?.firstIndex(of: ":"), file: file, line: line)
        XCTAssertLessThanOrEqual(5, cell.label.text?.count ?? 0, file: file, line: line)
    }

    private func happening(at: IndexPath) -> DayCell {
        sut.viewRoot.happeningsCollection.dataSource?.collectionView(
            sut.viewRoot.happeningsCollection,
            cellForItemAt: at) as! DayCell
    }

    private func addHappening(at: Date) {
        sut.createHappeningService?.serve(CreateHappeningServiceArgument(eventId: eventId, date: at))
    }

    private var happeningsAmount: Int { sut.viewRoot.happeningsCollection.numberOfItems(inSection: 0) }
}
