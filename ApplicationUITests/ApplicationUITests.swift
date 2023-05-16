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

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        firstEventCell = app.tables.firstMatch.cells["EventCell"].firstMatch
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
}
