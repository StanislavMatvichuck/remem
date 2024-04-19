//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class AppPreviewRecorder: XCTestCase {
    var firstEventCell: XCUIElement! { cell(at: 0) }
    var field: XCUIElement! { app.textFields.element }
    let recording: Bool = false
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    var app: XCUIApplication!

    override func setUp() { super.setUp(); app = XCUIApplication() }
    override func tearDown() { app = nil; super.tearDown() }

    func test01_addingEvents() {
        executeWith(mode: .appPreview02_addingEvents, recording: recording) {
            createEventButton.tap()
            submitFirstEvent()

            createEventButton.tap()
            submitSecondEvent()

            createEventButton.tap()
            submitThirdEvent()

            swipeCell(at: 1)
            swipeCell(at: 2)
            swipeCell(at: 3)

            /// Open event details
            cell(at: 2).tap()
            app.collectionViews.firstMatch.swipeRight()
            app.collectionViews.firstMatch.swipeLeft()
            app.scrollViews[UITestAccessibilityIdentifier.eventDetailsScroll.rawValue].swipeUp()

            sleep(1)

            app.scrollViews[UITestAccessibilityIdentifier.eventDetailsScroll.rawValue].swipeDown()

            sleep(1)

            weekCell(at: 0).tap()

            sleep(1)
        }
    }

    // MARK: - Private
    private func pressRecordButtonInControlCenter() {
        openControlCenter(from: app)
        sleep(1)
        tapRecordButton()
        sleep(1)
        closeControlCenter(from: app)
        sleep(2)
    }

    private func tapRecordButton() { springboard.buttons["Screen Recording"].tap() }

    private func weekCell(at index: Int) -> XCUIElement { app.collectionViews.firstMatch.cells.element(boundBy: index) }

    private func submitSecondEvent() {
        field.typeText("Coffee ")

        let coffeeEmoji = app.buttons["☕️"]
        coffeeEmoji.tap()

        app.keyboards.buttons["Done"].tap()
    }

    private func submitThirdEvent() {
        field.typeText("Fitness ")

        let coffeeEmoji = app.buttons["👟"]
        coffeeEmoji.tap()

        app.keyboards.buttons["Done"].tap()
    }

    private func submitFirstEvent() {
        field.typeText("Car broke down 🚙")
        app.keyboards.buttons["Done"].tap()
    }

    // MARK: - Elements querying
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch.cells.matching(
            identifier: UITestAccessibilityIdentifier.buttonCreteEvent.rawValue
        ).firstMatch
    }

    private func executeWith(mode: LaunchMode, recording: Bool = false, block: () -> Void = {}) {
        app.launchArguments = [mode.rawValue]
        app.launch()
        if recording { pressRecordButtonInControlCenter() }
        block()
        if recording { pressRecordButtonInControlCenter() }
    }

    private func openControlCenter(from app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.01))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.2))
        start.press(forDuration: 0.1, thenDragTo: end)
    }

    private func closeControlCenter(from app: XCUIApplication) { app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9)).tap() }

    private func swipeCell(at index: Int) {
        let event = cell(at: index)
        let value = event.descendants(matching: .staticText)[UITestAccessibilityIdentifier.eventValue.rawValue]
        let swiper = event.descendants(matching: .any)[UITestAccessibilityIdentifier.eventSwiper.rawValue]

        swiper.press(
            forDuration: 0.1,
            thenDragTo: value,
            withVelocity: 150,
            thenHoldForDuration: 0.1
        )
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }
}
