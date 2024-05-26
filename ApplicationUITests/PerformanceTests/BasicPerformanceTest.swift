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

    func test_swipeFirstEvent() {
        swipeCell(at: 1)
        sleep(5)
        swipeCell(at: 2)
        sleep(5)
        swipeCell(at: 1)
    }

    func test_eventRemoval() {}
    func test_scroll() {
        app.collectionViews.firstMatch.swipeUp(velocity: .fast)
        sleep(5)
        app.collectionViews.firstMatch.swipeDown(velocity: .fast)
    }

    func test_ordering() {}
    func test_eventOrderingManual() {}
    func test_tapFirstEvent_tapFirstDay_goBack() {}
    func test_tapFirstEvent_tapFirstDay_addHappening() {}
    func test_tapFirstEvent_scroll() {}

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
