//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewModelTests: XCTestCase {
    // MARK: - Setup

    var sut: EventsListViewModel!
    var container: EventsListContainer!
    var secondEvent: Event!

    override func setUp() {
        super.setUp()
        configureSUTWithThreeEvents()
    }

    override func tearDown() {
        sut = nil
        container = nil
        secondEvent = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_configureAnimationForEventCells_usingOldValue_addedHappeningForSecondEvent_neighboursReceiveAnimations() {
        arrangeWithSecondEventSwiped()

        XCTAssertEqual(firstCell.animation, .aboveSwipe)
        XCTAssertEqual(secondCell.animation, .swipe)
        XCTAssertEqual(thirdCell.animation, .belowSwipe)
    }

    func test_configureAnimationForEventCells_usingSameValue_noneForAllCells() {
        sut.configureAnimationForEventCells(sut)

        XCTAssertEqual(firstCell.animation, .none)
        XCTAssertEqual(secondCell.animation, .none)
        XCTAssertEqual(thirdCell.animation, .none)
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfSecondEventCell_returnsFirst() {
        XCTAssertEqual(sut.eventCellRelative(to: secondCell, offset: -1), firstCell)
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfFirstEventCell_returnsNil() {
        XCTAssertNil(sut.eventCellRelative(to: firstCell, offset: -1))
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfSecondEventCell_returnsThird() {
        XCTAssertEqual(sut.eventCellRelative(to: secondCell, offset: 1), thirdCell)
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfThirdEventCell_returnsNil() {
        XCTAssertNil(sut.eventCellRelative(to: thirdCell, offset: 1))
    }

    // MARK: - Creation

    private func configureSUTWithThreeEvents() {
        let eventA = Event(name: "A", dateCreated: DayIndex.referenceValue.date)
        let eventB = Event(name: "B", dateCreated: DayIndex.referenceValue.date)
        let eventC = Event(name: "C", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(eventA)
        appC.commander.save(eventB)
        appC.commander.save(eventC)

        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
        self.container = container
        secondEvent = eventB
    }

    private func arrangeWithSecondEventSwiped() {
        secondEvent.addHappening(date: DayIndex.referenceValue.date)
        container.commander.save(secondEvent)
        // Imitates controller update cycle with didSet observer
        let oldValue = sut
        sut = container.makeEventsListViewModel(nil)
        sut.configureAnimationForEventCells(oldValue)
    }

    private var eventCells: [EventCellViewModel] { sut.cells(for: .events) as! [EventCellViewModel] }
    private var firstCell: EventCellViewModel { eventCells[0] }
    private var secondCell: EventCellViewModel { eventCells[1] }
    private var thirdCell: EventCellViewModel { eventCells[2] }
}
