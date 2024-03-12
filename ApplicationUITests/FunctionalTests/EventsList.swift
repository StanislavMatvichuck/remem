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
        app = nil
        super.tearDown()
    }

    // MARK: - Tests
    func test_eventAddedToEmptyList() {
        let createdEventName = "Event.name"
        createEventButton.tap()
        eventNameInput.typeText(createdEventName)
        submitKeyboard()

        let createdEventCell = cell(at: 1)
        let valueLabel = createdEventCell.descendants(matching: .staticText)[UITestAccessibilityIdentifier.eventTitle.rawValue]
        XCTAssertTrue(valueLabel.waitForExistence(timeout: 1.0), "List must show created event")
        XCTAssertEqual(valueLabel.label, createdEventName, "Event name must match entered name")
    }

    func test_eventCanBeRemoved() {
        /// Arrange: create event
        let createdEventName = "Deleted event"
        createEventButton.tap()
        eventNameInput.typeText(createdEventName)
        submitKeyboard()

        /// Act: perform drag and drop
        let createdEventCell = cell(at: 1)
        let removeArea = app.descendants(matching: .any)[UITestAccessibilityIdentifier.removeEventArea.rawValue]

        createdEventCell.press(
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
        let createdEventName = "Swiped event"
        createEventButton.tap()
        eventNameInput.typeText(createdEventName)
        submitKeyboard()

        /// Act: swipe
        let createdEventCell = cell(at: 1)
        let value = createdEventCell.descendants(matching: .staticText)[UITestAccessibilityIdentifier.eventValue.rawValue]
        let swiper = createdEventCell.descendants(matching: .any)[UITestAccessibilityIdentifier.eventSwiper.rawValue]

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
        let createdEventName = "Visited event"
        createEventButton.tap()
        eventNameInput.typeText(createdEventName)
        submitKeyboard()

        let createdEventCell = cell(at: 1)
        let value = createdEventCell.descendants(matching: .staticText)[UITestAccessibilityIdentifier.eventValue.rawValue]
        let swiper = createdEventCell.descendants(matching: .any)[UITestAccessibilityIdentifier.eventSwiper.rawValue]

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
        createdEventCell.tap()

        let eventDetailsBackToEventsListButton = app.navigationBars.buttons.firstMatch
        eventDetailsBackToEventsListButton.tap()

        /// Assert: hint must have final state
        XCTAssertEqual(hint.label, "long tap to change order", "hint changes after event is visited")
    }

    /// This test is not repeatable because eventSorting repository reads value from previous test
    func test_orderingByDate() {
        /// Arrange: create events
        let createdEventNames = ["C", "B", "A"]

        for name in createdEventNames {
            createEventButton.tap()
            eventNameInput.typeText(name)
            submitKeyboard()
        }

        let first = cell(at: 1).staticTexts[UITestAccessibilityIdentifier.eventTitle.rawValue]
        let second = cell(at: 2).staticTexts[UITestAccessibilityIdentifier.eventTitle.rawValue]
        let third = cell(at: 3).staticTexts[UITestAccessibilityIdentifier.eventTitle.rawValue]

        /// Act: change ordering to alphabetical
        let orderingButton = app.navigationBars.buttons.firstMatch
        orderingButton.tap()

        let byNameOrderingButton = app.staticTexts.matching(identifier: UITestAccessibilityIdentifier.orderingVariant.rawValue)["By name"]
        byNameOrderingButton.tap()

        /// Assert: events sorted alphabetically
        XCTAssertEqual(first.label, "A")
        XCTAssertEqual(second.label, "B")
        XCTAssertEqual(third.label, "C")

        /// Act: change ordering by date of creation
        let byDateOrderingButton = app.staticTexts.matching(identifier: UITestAccessibilityIdentifier.orderingVariant.rawValue)["By date created"]
        byDateOrderingButton.tap()

        /// Assert: events are reordered by date
        XCTAssertEqual(first.label, "C")
        XCTAssertEqual(second.label, "B")
        XCTAssertEqual(third.label, "A")
    }

    // MARK: - Private
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch
            .cells.matching(identifier:
                UITestAccessibilityIdentifier.buttonCreteEvent.rawValue
            ).firstMatch
    }

    private var hint: XCUIElement {
        app.collectionViews.firstMatch
            .cells.matching(identifier:
                UITestAccessibilityIdentifier.hint.rawValue
            ).firstMatch.staticTexts.firstMatch
    }

    private var eventNameInput: XCUIElement {
        app.textFields.firstMatch
    }

    private func submitKeyboard() {
        app.keyboards.buttons["Done"].tap()
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }
}
