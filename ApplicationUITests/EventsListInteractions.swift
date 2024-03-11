//
//  EventsListInteractions.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 29.01.2024.
//

import XCTest

final class EventsListInteractions: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = [LaunchMode.eventsListInteractions.rawValue]
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - Tests
    func test_swipeSecondEvent() {
        swipeCell(at: 2)
        swipeCell(at: 2)
        swipeCell(at: 2)
        swipeCell(at: 2)
        swipeCell(at: 2)
    }

    func test_tapSecondEvent() {
        tapCell(at: 2)
    }

    // MARK: - Private
    private func swipeCell(at index: Int) {
        let cell = cell(at: index)
        let swiper = cell.descendants(matching: .any)["Swiper"]
        let valueLabel = cell.descendants(matching: .any)[UITestAccessibilityIdentifier.eventCellValue.rawValue]

        swiper.press(
            forDuration: 0,
            thenDragTo: valueLabel,
            withVelocity: 50,
            thenHoldForDuration: 0.1
        )

        sleep(1)
    }

    private func tapCell(at index: Int) {
        let cell = cell(at: index)
        let swiper = cell.descendants(matching: .any)["Swiper"]

        swiper.tap()
    }

    private func cell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }
}
