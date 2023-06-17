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
    private let recording: Bool = true

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    let pauseSeconds: UInt32 = 0

    // MARK: - AppPreview02

    func test01_addingEvents() {
        executeWith(mode: .appPreview02_addingEvents, recording: recording) {
            footer.tap()
            submitFirstEvent()
            sleep(pauseSeconds)

            footer.tap()
            submitSecondEvent()
            sleep(pauseSeconds)

            footer.tap()
            submitThirdEvent()
        }
    }

    func test02_swipingEvents() {
        executeWith(mode: .appPreview02_swipingEvents, recording: recording) {
            swipeCell(at: 0)
            swipeCell(at: 1)
            swipeCell(at: 2)

            swipeCell(at: 2)
            swipeCell(at: 1)
            swipeCell(at: 2)
        }
    }

    func test03_viewDetailsAndExport() {
        executeWith(mode: .appPreview02_viewDetailsAndExport, recording: recording) {
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
            
            /// Close mail share modal
            app.buttons["Mail.sendButton"].tap()
        }
    }

    func test04_addWeeklyGoal() {
        executeWith(mode: .appPreview02_addWeeklyGoal, recording: recording) {
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
    }

    // MARK: - AppPreview03

    func test05_widget() {
        executeWith(mode: .appPreview03_widget, recording: recording) {
            XCUIDevice.shared.press(XCUIDevice.Button.home)
            sleep(11)
            app.activate()
            sleep(pauseSeconds)
        }
    }

    func test06_darkMode() {
        executeWith(mode: .appPreview03_darkMode, recording: recording) {
            toggleDarkModeInControlCenter()
            cell(at: 2).tap()
            app.swipeUp()
            app.swipeDown()
            app.navigationBars.buttons.firstMatch.tap()
        }
    }

    // MARK: - Private

    private func executeWith(mode: LaunchMode, recording: Bool = false, block: () -> Void = {}) {
        app.launchArguments = [mode.rawValue]
        app.launch()
        if recording { pressRecordButtonInControlCenter() }
        block()
        if recording { pressRecordButtonInControlCenter() }
    }

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

    private func submitSecondEvent() {
        field.typeText("Coffee ")

        let coffeeEmoji = app.buttons["☕️"]
        coffeeEmoji.tap()

        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }

    private func submitThirdEvent() {
        field.typeText("Fitness ")

        let coffeeEmoji = app.buttons["👟"]
        coffeeEmoji.tap()

        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }

    private func submitFirstEvent() {
        field.typeText("Car broke down 🚙")

        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }

    private func pressRecordButtonInControlCenter() {
        openControlCenter(from: app)
        sleep(1)
        tapRecordButton()
        sleep(1)
        closeControlCenter(from: app)
        sleep(2)
    }

    private func toggleDarkModeInControlCenter() {
        openControlCenter(from: app)
//        sleep(1)
        tapBrightness()
//        sleep(1)
        tapDarkMode()
//        sleep(1)
        closeControlCenter(from: app)
//        sleep(1)
        closeControlCenter(from: app)
    }

    private func openControlCenter(from app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.01))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.2))
        start.press(forDuration: 0.1, thenDragTo: end)
    }

    private func closeControlCenter(from app: XCUIApplication) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9)).tap()
    }

    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    private func tapRecordButton() {
        springboard.buttons["Screen Recording"].tap()
    }

    private func tapBrightness() {
        springboard.otherElements["Brightness"].press(forDuration: 2)
    }

    private func tapDarkMode() {
        springboard.buttons["Dark Mode"].tap()
    }
}
