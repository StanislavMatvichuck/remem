//
//  EventsList.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 11.03.2024.
//

import XCTest

final class EventsListFunctionalTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = [LaunchMode.eventsListFunctionalTests.rawValue]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    // MARK: - Tests
    func test_eventAddedToEmptyList() {
        let createdEventName = "Event.name"
        createEventWith(name: createdEventName)

        XCTAssertTrue(firstEventTitle.waitForExistence(timeout: 1.0), "List must show created event")
        XCTAssertEqual(firstEventTitle.label, createdEventName, "Event name must match entered name")
    }

    func test_eventCanBeRemoved() {
        /// Arrange: create event
        createEventWith(name: "Deleted event")

        /// Act: perform drag and drop
        let removeArea = app.descendants(matching: .any)[UITestID.removeEventArea.rawValue]

        firstEvent.press(
            forDuration: 1.0,
            thenDragTo: removeArea,
            withVelocity: 150,
            thenHoldForDuration: 0.1
        )

        sleep(1)

        /// Assert: event is not in the list anymore
        let cellsAmount = app.collectionViews.cells.count
        XCTAssertEqual(cellsAmount, 2, "Event is removed, only hint and create event button remain")
    }

    func test_eventValueIncreasedAfterSwipe() {
        /// Arrange: create event
        createEventWith(name: "Swiped event")

        /// Act: swipe
        let value = firstEvent.descendants(matching: .staticText)[UITestID.eventValue.rawValue]
        let swiper = firstEvent.descendants(matching: .any)[UITestID.eventSwiper.rawValue]

        XCTAssertEqual(value.label, "0", "New event has no swipes")

        swiper.press(
            forDuration: 0.1,
            thenDragTo: value,
            withVelocity: 150,
            thenHoldForDuration: 0.1
        )

        sleep(1)

        /// Assert: value has increased
        XCTAssertEqual(value.label, "1", "Swipe is recorded and new value is visible")
    }

    func test_eventIsVisitedAfterTap() {
        /// Arrange: create event and swipe it
        createEventWith(name: "Visited event")

        let value = firstEvent.descendants(matching: .staticText)[UITestID.eventValue.rawValue]
        let swiper = firstEvent.descendants(matching: .any)[UITestID.eventSwiper.rawValue]

        XCTAssertEqual(value.label, "0", "New event has no swipes")

        swiper.press(
            forDuration: 0.1,
            thenDragTo: value,
            withVelocity: 150,
            thenHoldForDuration: 0.1
        )

        XCTAssertEqual(hint.label, "Press to see details", "hint asks to tap event")

        sleep(1)

        /// Act: open event details and return back
        firstEvent.tap()

        let eventDetailsBackToEventsListButton = app.navigationBars.buttons.firstMatch
        eventDetailsBackToEventsListButton.tap()

        /// Assert: hint must have final state
        XCTAssertEqual(hint.label, "long tap to change order", "hint changes after event is visited")
    }

    /// This test is not repeatable because eventSorting repository reads value from previous test
    func test_orderingByDate() {
        /// Arrange: create events
        for name in ["C", "B", "A"] { createEventWith(name: name) }

        /// Act: change ordering to alphabetical
        let orderingButton = app.navigationBars.buttons.firstMatch
        orderingButton.tap()

        _ = byNameOrderingButton.waitForExistence(timeout: 1.0)
        byNameOrderingButton.tap()

        /// Assert: events sorted alphabetically
        XCTAssertEqual(firstEventTitle.label, "A")
        XCTAssertEqual(secondEventTitle.label, "B")
        XCTAssertEqual(thirdEventTitle.label, "C")

        /// Act: change ordering by date of creation
        _ = byDateOrderingButton.waitForExistence(timeout: 1.0)
        byDateOrderingButton.tap()

        /// Assert: events are reordered by date
        XCTAssertEqual(firstEventTitle.label, "C")
        XCTAssertEqual(secondEventTitle.label, "B")
        XCTAssertEqual(thirdEventTitle.label, "A")
    }

    func test_dragAndDropToReorder() {
        /// Arrange: create events
        for name in ["A", "B", "C"] { createEventWith(name: name) }

        _ = thirdEventTitle.waitForExistence(timeout: 1.0)

        /// Act: drag third event to first
        thirdEventTitle.press(
            forDuration: 1.0,
            thenDragTo: firstEventTitle,
            withVelocity: 150,
            thenHoldForDuration: 0.1
        )

        /// Assert: manual ordering appears after drag and drop
        _ = manualOrderingButton.waitForExistence(timeout: 1.0)

        /// Assert: manual ordering is applied
        XCTAssertEqual(firstEventTitle.label, "C")
        XCTAssertEqual(secondEventTitle.label, "A")
        XCTAssertEqual(thirdEventTitle.label, "B")

        /// Kind of tearDown to reset testing repository to initial state
        let orderingButton = app.navigationBars.buttons.firstMatch
        orderingButton.tap()

        _ = byNameOrderingButton.waitForExistence(timeout: 1.0)
        byNameOrderingButton.tap()
    }

    // MARK: - Private

    //
    // Elements querying
    //
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch.cells.matching(
            identifier: UITestID.buttonCreteEvent.rawValue
        ).firstMatch
    }

    private var hint: XCUIElement {
        app.collectionViews.firstMatch.cells.matching(
            identifier: UITestID.hint.rawValue
        ).firstMatch.staticTexts.firstMatch
    }

    private var eventNameInput: XCUIElement {
        app.textFields.firstMatch
    }

    private var firstEvent: XCUIElement { cell(at: 1) }

    private var firstEventTitle: XCUIElement {
        firstEvent.descendants(matching: .staticText)[UITestID.eventTitle.rawValue]
    }

    private var secondEventTitle: XCUIElement {
        cell(at: 2).descendants(matching: .staticText)[UITestID.eventTitle.rawValue]
    }

    private var thirdEventTitle: XCUIElement {
        cell(at: 3).descendants(matching: .staticText)[UITestID.eventTitle.rawValue]
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }

    private var byNameOrderingButton: XCUIElement {
        app.staticTexts.matching(
            identifier: UITestID.orderingVariant.rawValue
        )["By name"]
    }

    private var byDateOrderingButton: XCUIElement {
        app.staticTexts.matching(
            identifier: UITestID.orderingVariant.rawValue
        )["By date created"]
    }

    private var manualOrderingButton: XCUIElement {
        app.staticTexts.matching(
            identifier: UITestID.orderingVariant.rawValue
        )["Manual"]
    }

    //
    // User input
    //

    private func createEventWith(name: String) {
        createEventButton.tap()
        eventNameInput.typeText(name)
        submitKeyboard()
    }

    private func submitKeyboard() {
        app.keyboards.buttons["Done"].tap()
    }
}
