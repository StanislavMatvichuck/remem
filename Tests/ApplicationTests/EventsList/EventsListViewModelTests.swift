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
    var sut: EventsListViewModel!

    override func setUp() {
        super.setUp()
        let appC = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_configureAnimationForEventCells_usingOldValue_addedHappeningForSecondEvent_neighboursReceiveAnimations() {
        configureSUTWithThreeEventsAndOldValue()
        let eventCells = sut.cells(for: .events)
        guard
            let firstCell = eventCells[0] as? EventCellViewModel,
            let secondCell = eventCells[1] as? EventCellViewModel,
            let thirdCell = eventCells[2] as? EventCellViewModel
        else { return XCTFail() }

        XCTAssertEqual(firstCell.animation, .aboveSwipe)
        XCTAssertEqual(secondCell.animation, .swipe)
        XCTAssertEqual(thirdCell.animation, .belowSwipe)
    }

    func test_configureAnimationForEventCells_usingSameValue_noneForAllCells() {
        configureSUTWithThreeEvents()

        sut.configureAnimationForEventCells(sut)
        let eventCells = sut.cells(for: .events)

        if let cell = eventCells[0] as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }

        if let cell = eventCells[1] as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }

        if let cell = eventCells[2] as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfSecondEventCell_returnsFirst() {
        configureSUTWithThreeEvents()
        let eventCells = sut.cells(for: .events)
        guard
            let firstCell = eventCells[0] as? EventCellViewModel,
            let secondCell = eventCells[1] as? EventCellViewModel
        else { return XCTFail() }

        XCTAssertEqual(sut.eventCellRelative(to: secondCell, offset: -1), firstCell)
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfFirstEventCell_returnsNil() {
        configureSUTWithThreeEvents()
        let eventCells = sut.cells(for: .events)
        guard
            let firstCell = eventCells[0] as? EventCellViewModel
        else { return XCTFail() }

        XCTAssertNil(sut.eventCellRelative(to: firstCell, offset: -1))
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfSecondEventCell_returnsThird() {
        configureSUTWithThreeEvents()
        let eventCells = sut.cells(for: .events)
        guard
            let secondCell = eventCells[1] as? EventCellViewModel,
            let thirdCell = eventCells[2] as? EventCellViewModel
        else { return XCTFail() }

        XCTAssertEqual(sut.eventCellRelative(to: secondCell, offset: 1), thirdCell)
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfThirdEventCell_returnsNil() {
        configureSUTWithThreeEvents()
        let eventCells = sut.cells(for: .events)
        guard
            let thirdCell = eventCells[2] as? EventCellViewModel
        else { return XCTFail() }

        XCTAssertNil(sut.eventCellRelative(to: thirdCell, offset: 1))
    }

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
    }

    private func configureSUTWithOneEvent() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(event)
        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
    }

    private func configureSUTWithThreeEventsAndOldValue() {
        let eventA = Event(name: "A", dateCreated: DayIndex.referenceValue.date)
        let eventB = Event(name: "B", dateCreated: DayIndex.referenceValue.date)
        let eventC = Event(name: "C", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(eventA)
        appC.commander.save(eventB)
        appC.commander.save(eventC)
        let container = EventsListContainer(appC)
        let oldValue = container.makeEventsListViewModel(nil)

        eventB.addHappening(date: DayIndex.referenceValue.date)
        appC.commander.save(eventB)

        sut = container.makeEventsListViewModel(nil)
        sut.configureAnimationForEventCells(oldValue)
    }
}
