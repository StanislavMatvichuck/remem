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

    let pauseSeconds: UInt32 = 1

    func test_recordPresentationSequence_addingFreshEvents() {
        app.launchArguments = ["empty"]
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
        
        cell(at: 1).tap()
        sleep(2)
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

    private func submitFirstEvent() {
//        field.typeText("Coffee ")
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
        field.typeText("Any event you want to track")
        sleep(pauseSeconds)
        app.keyboards.buttons["Done"].tap()
    }
}
