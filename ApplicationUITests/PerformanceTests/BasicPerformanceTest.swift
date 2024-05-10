//
//  BasicPerformanceTest.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 07.05.2024.
//

import XCTest

final class BasicPerformanceTest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = [LaunchMode.performanceTest.rawValue]
        app.launch()
    }

    override func tearDown() { app = nil; super.tearDown() }

    func test_makePerformanceData() {
        app = XCUIApplication()
        app.launchArguments = [LaunchMode.performanceTestWritesData.rawValue]
        app.launch()

        sleep(600)

        let cell = cell(at: 1)

        XCTAssertEqual(cell.descendants(matching: .staticText).element(boundBy: 1).label, "Event#1")
    }

    func test_tapFirstEvent_goBack() {
        let cell = cell(at: 1)

        cell.tap()

        sleep(1)

        let eventDetailsBackToEventsListButton = app.navigationBars.buttons.firstMatch
        eventDetailsBackToEventsListButton.tap()
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }
}
