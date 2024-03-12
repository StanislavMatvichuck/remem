//
//  EventDetails.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 12.03.2024.
//

import XCTest

final class EventDetailsFunctionalTests: XCTestCase {
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
    func test_happeningCanBeAddedWithinDayDetails() {
        createEventWith(name: "EventDetails")
        firstEvent.tap()

        let firstDayOfWeek = app.descendants(matching: .any)[UITestAccessibilityIdentifier.weekDay.rawValue].firstMatch
        _ = firstDayOfWeek.waitForExistence(timeout: 1.0)
        firstDayOfWeek.tap()

        let happeningsList = app.collectionViews[UITestAccessibilityIdentifier.dayDetailsHappeningsList.rawValue].firstMatch

        XCTAssertEqual(happeningsList.cells.count, 0)

        let addHappeningButton = app.descendants(matching: .any)[UITestAccessibilityIdentifier.dayDetailsAddHappening.rawValue].firstMatch
        _ = addHappeningButton.waitForExistence(timeout: 1.0)
        addHappeningButton.tap()

        sleep(1)

        let happening = app.descendants(matching: .cell)[UITestAccessibilityIdentifier.dayDetailsHappening.rawValue].firstMatch
        _ = happening.waitForExistence(timeout: 1.0)

        /// Assert: happening added
        XCTAssertEqual(happeningsList.cells.count, 1)
    }

    // MARK: - Private

    //
    // Elements querying
    //
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch.cells.matching(
            identifier: UITestAccessibilityIdentifier.buttonCreteEvent.rawValue
        ).firstMatch
    }

    private var eventNameInput: XCUIElement {
        app.textFields.firstMatch
    }

    private var firstEvent: XCUIElement { cell(at: 1) }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
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
