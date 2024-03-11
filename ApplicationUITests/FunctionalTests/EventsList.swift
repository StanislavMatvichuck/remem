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

    // MARK: - Private
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch
            .cells.matching(identifier:
                UITestAccessibilityIdentifier.buttonCreteEvent.rawValue
            ).firstMatch
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
