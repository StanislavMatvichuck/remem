//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class ApplicationUITests: XCTestCase {
    private var app: XCUIApplication!
    private var firstEventCell: XCUIElement! { app.tables.firstMatch.cells["EventCell"].firstMatch }
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

    func testVolume() {
        app.launchArguments = ["eventsAmount 100"]
        app.launch()

        firstEventCell.tap()

        let detailsScreenBack = app.navigationBars.buttons.firstMatch
        detailsScreenBack.waitForExistence(timeout: 5)
        detailsScreenBack.tap()
    }

    func test_swipe() {
        app.launchArguments = ["eventsAmount 1"]
        app.launch()

        let swiper = firstEventCell.descendants(matching: .any)["Swiper"]
        let valueLabel = firstEventCell.staticTexts.element(boundBy: 1)

        swiper.press(forDuration: 0, thenDragTo: valueLabel)
    }

    func test_recordPresentationSequence_addingFreshEvents() {
        app.launchArguments = ["eventsAmount 0"]
        app.launch()

        footer.tap()
        submitFirstEvent()

        footer.tap()
        submitSecondEvent()
    }

    private func submitFirstEvent() {
        field.typeText("Coffee")
        let coffeeEmoji = app.buttons["☕️"]
        coffeeEmoji.tap()
        app.keyboards.buttons["Done"].tap()
    }

    private func submitSecondEvent() {
        field.typeText("Second event title")
        app.keyboards.buttons["Done"].tap()
    }

    private func submitThirdEvent() {
        field.typeText("Third event title")
        app.keyboards.buttons["Done"].tap()
    }
}
