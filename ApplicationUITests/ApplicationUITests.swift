//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class ApplicationUITests: XCTestCase {
    func testVolume() {
        let app = XCUIApplication()
        app.launchArguments = ["eventsAmount 100"]
        app.launch()

        app.tables.firstMatch.cells["EventItem"].firstMatch.tap()
        app.navigationBars.buttons.firstMatch.waitForExistence(timeout: 5)
        app.navigationBars.buttons.firstMatch.tap()
    }

    func test_swipe() {
        let app = XCUIApplication()
        app.launchArguments = ["eventsAmount 1"]
        app.launch()

        let firstEvent = app.tables.firstMatch.cells["EventItem"].firstMatch
        let swiper = firstEvent.descendants(matching: .any)["Swiper"]
        let valueLabel = firstEvent.staticTexts.element(boundBy: 1)

        swiper.press(forDuration: 0, thenDragTo: valueLabel)
    }
}
