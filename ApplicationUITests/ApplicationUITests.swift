//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class ApplicationUITests: XCTestCase {
    private var app: XCUIApplication!
    private var firstEventCell: XCUIElement! { cell(at: 0) }
    private var footer: XCUIElement! { app.tables.firstMatch.cells["FooterCell"].firstMatch }
    private var field: XCUIElement! { app.textFields.element }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func test_swipe() {
        app.launchArguments = [LaunchMode.singleEvent.rawValue]
        app.launch()

        let swiper = firstEventCell.descendants(matching: .any)["Swiper"]
        let valueLabel = firstEventCell.staticTexts.element(boundBy: 1)

        swiper.press(forDuration: 0, thenDragTo: valueLabel)
    }

    let pauseSeconds: UInt32 = 1

    // MARK: - AppPreview02

    func test_recordAppPreview02_addingEvents_swipingEvents() {
        app.launchArguments = [LaunchMode.appPreview02_addingEventsAndSwiping.rawValue]
        app.launch()

        footer.tap()
        submitFirstEvent()
        sleep(pauseSeconds)

        footer.tap()
        submitSecondEvent()
        sleep(pauseSeconds)

        footer.tap()
        submitThirdEvent()
        sleep(pauseSeconds)

        swipeCell(at: 0)
        swipeCell(at: 1)
        swipeCell(at: 2)
        swipeCell(at: 1)
        swipeCell(at: 0)
        swipeCell(at: 1)
        sleep(pauseSeconds)
    }

    func test_recordAppPreview02_viewAndExport() {
        app.launchArguments = [LaunchMode.appPreview02_viewAndExport.rawValue]
        app.launch()

        /// Open event details
        cell(at: 1).tap()
        sleep(pauseSeconds)

        app.collectionViews.firstMatch.swipeRight()
        sleep(pauseSeconds)

        app.collectionViews.firstMatch.swipeLeft()
        sleep(pauseSeconds)

        app.scrollViews[UITestAccessibilityIdentifier.eventDetailsScroll.rawValue].swipeUp()
        sleep(pauseSeconds)

        /// Open pdf report
        app.buttons[UITestAccessibilityIdentifier.buttonPdfCreate.rawValue].tap()
        sleep(pauseSeconds)

        app.buttons[UITestAccessibilityIdentifier.buttonPdfShare.rawValue].tap()
        sleep(pauseSeconds)

        /// Open mail share modal
        app.cells["Mail"].tap()
        sleep(pauseSeconds)

        app.textFields["toField"].tap()
        app.textFields["toField"].typeText("someEmail@gmail.com")
        app.textViews["subjectField"].tap()
        app.textViews["subjectField"].typeText("Coffee drinking report")
        app.buttons["Mail.sendButton"].tap()

        /// Back to event details
        app.navigationBars.buttons.firstMatch.tap()
        /// Back to list
        app.navigationBars.buttons.firstMatch.tap()
        sleep(pauseSeconds)
    }

    func test_recordAppPreview02_addWeeklyGoal() {
        app.launchArguments = [LaunchMode.appPreview02_addWeeklyGoal.rawValue]
        app.launch()

        /// Open event details
        cell(at: 2).tap()
        sleep(pauseSeconds)

        /// Add goal
        app.textFields[UITestAccessibilityIdentifier.textFieldGoal.rawValue].tap()
        sleep(pauseSeconds)
        app.keys["5"].tap()
        app.otherElements[UITestAccessibilityIdentifier.buttonGoalDone.rawValue].tap()
        sleep(pauseSeconds)

        /// Back to list
        app.navigationBars.buttons.firstMatch.tap()
        sleep(pauseSeconds)

        swipeCell(at: 2)
        sleep(pauseSeconds)
        swipeCell(at: 2)
        sleep(pauseSeconds)
    }

    // MARK: - AppPreview03

    func test_recordAppPreview03_widget() {
        // open app
        app.launchArguments = [LaunchMode.appPreview02_widget.rawValue]
        app.launch()
        sleep(pauseSeconds)
        // hide app to allow widget adding
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(pauseSeconds)
    }

    func test_recordAppPreview03_eventsListSorting() {}
    func test_recordAppPreview03_darkMode() {}
    func test_recordAppPreview03_localization() {}

    // MARK: - Private

    private func swipeCell(at index: Int) {
        let cell = cell(at: index)
        let swiper = cell.descendants(matching: .any)["Swiper"]
        let valueLabel = cell.staticTexts.element(boundBy: 1)

        swiper.press(forDuration: 0, thenDragTo: valueLabel)
        sleep(pauseSeconds)
    }

    private func cell(at index: Int) -> XCUIElement {
        app.tables.firstMatch.cells.element(boundBy: index)
    }

    private func weekCell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }

    /// This method required auto capitalization to be turned off
    /// Auto correction better be turned off too
    private func submitFirstEvent() {
        app.keyboards.buttons["shift"].tap()
        app.keys["C"].tap()
        app.keys["o"].tap()
        app.keys["f"].tap()
        app.keys["f"].tap()
        app.keys["e"].tap()
        app.keys["e"].tap()
        app.keys["space"].tap()

        let coffeeEmoji = app.buttons["☕️"]
        coffeeEmoji.tap()

        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }

    private func submitSecondEvent() {
        app.keyboards.buttons["shift"].tap()
        app.keys["F"].tap()
        app.keys["i"].tap()
        app.keys["t"].tap()
        app.keys["n"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()
        app.keys["space"].tap()

        let coffeeEmoji = app.buttons["👟"]
        coffeeEmoji.tap()

        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }

    private func submitThirdEvent() {
        field.typeText("Any event you want to count")
        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }
}
