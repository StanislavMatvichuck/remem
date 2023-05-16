//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class ApplicationUITests: XCTestCase {
    private var app: XCUIApplication!
    private var firstEventCell: XCUIElement!
    private var footer: XCUIElement!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        firstEventCell = app.tables.firstMatch.cells["EventCell"].firstMatch
        footer = app.tables.firstMatch.cells["FooterCell"].firstMatch
    }

    override func tearDown() {
        firstEventCell = nil
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

        sleep(1)

        app.keys["C"].tap()
        app.keys["o"].tap()
        app.keys["f"].tap()
        app.keys["f"].tap()
        app.keys["e"].tap()
        app.keys["e"].tap()
        app.keys["space"].tap()

        sleep(1)

        app.keyboards.buttons["Done"].tap()

        footer.tap()

        sleep(1)

        app.keys["W"].tap()
        app.keys["a"].tap()
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["r"].tap()
        app.keyboards.buttons["Done"].tap()

        sleep(1)
    }
}
