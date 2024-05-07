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
    let recording: Bool = true
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    var app: XCUIApplication!

    override func setUp() { super.setUp(); app = XCUIApplication() }
    override func tearDown() { app = nil; super.tearDown() }

    func test_recordPreview() {
        executeWith(mode: .appPreview, recording: recording) {
            createEventButton.tap()
            field.typeText("junk food 🌭")
            app.keyboards.buttons["Done"].tap()
            sleep(1)

            swipeCell(at: 2)
            sleep(1)

            ///
            /// Open event details
            ///
            cell(at: 1).tap()

            /// Next to rows do not work because no predefined data involved
            app.collectionViews.firstMatch.swipeRight()
            app.collectionViews.firstMatch.swipeLeft()

            ///
            /// Scroll event details forth and back
            ///
//            app.scrollViews[UITestID.eventDetailsScroll.rawValue].swipeUp()
//            sleep(1)
//            app.scrollViews[UITestID.eventDetailsScroll.rawValue].swipeDown()
//            sleep(1)

            ///
            /// Add goal
            ///
            let createGoalButton = app.collectionViews.matching(
                identifier: UITestID.goalsList.rawValue).cells.matching(
                identifier: UITestID.buttonCreateGoal.rawValue
            ).firstMatch
            createGoalButton.tap()

            ///
            /// Positioning `EventDetails` to show created goal
            ///
            let month = app.descendants(matching: .staticText).element(
                matching: .staticText,
                identifier: UITestID.weekPageMonth.rawValue
            )
            let backButton = app.navigationBars.firstMatch.descendants(matching: .button).firstMatch
            month.press(forDuration: 0.01, thenDragTo: backButton, withVelocity: .slow, thenHoldForDuration: 0.01)

            ///
            /// Increase goal value
            ///
            let goalsList = app.collectionViews.matching(identifier: UITestID.goalsList.rawValue).firstMatch
            let increaseGoalValueButton = goalsList.cells.matching(identifier: UITestID.goal.rawValue).firstMatch.descendants(matching: .any)[UITestID.buttonIncreaseGoalValue.rawValue]
            sleep(1)
            increaseGoalValueButton.tap()
            increaseGoalValueButton.tap()
            sleep(1)

            ///
            /// Go back to list to swipe and achieve goal
            ///
            backButton.tap()
            sleep(1)

            swipeCell(at: 1)
            sleep(1)
            swipeCell(at: 1)
            sleep(1)
            swipeCell(at: 1)
            sleep(1)

            /// Go to event details and observe achieved goal
            cell(at: 1).tap()

            let month2 = app.descendants(matching: .staticText).element(
                matching: .staticText,
                identifier: UITestID.weekPageMonth.rawValue
            )
            let backButton2 = app.navigationBars.firstMatch.descendants(matching: .button).firstMatch
            month2.press(forDuration: 0.01, thenDragTo: backButton2, withVelocity: .slow, thenHoldForDuration: 0.01)
            sleep(1)

            ///
            /// Scroll to top and go to day details
            ///
//            app.scrollViews[UITestID.eventDetailsScroll.rawValue].swipeDown()
//            sleep(1)
//            weekCell(at: 1).tap()
//            sleep(2)
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

    private func weekCell(at index: Int) -> XCUIElement {
        app.collectionViews
            .firstMatch
            .cells
            .firstMatch
            .descendants(matching: .any)
            .element(matching: .any, identifier: UITestID.weekDay.rawValue)
            .firstMatch
    }

    // MARK: - Elements querying
    private var createEventButton: XCUIElement {
        app.collectionViews.firstMatch.cells.matching(
            identifier: UITestID.buttonCreteEvent.rawValue
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
        let value = event.descendants(matching: .staticText)[UITestID.eventValue.rawValue]
        let swiper = event.descendants(matching: .any)[UITestID.eventSwiper.rawValue]

        swiper.press(
            forDuration: 0.01,
            thenDragTo: value,
            withVelocity: 150,
            thenHoldForDuration: 0.01
        )
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }
}
