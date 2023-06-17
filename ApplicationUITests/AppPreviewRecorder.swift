//
//  AppPreviewRecording.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 17.06.2023.
//

import XCTest

class AppPreviewRecorder: XCTestCase {
    let recording: Bool = true
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - Used by subclasses
    func executeWith(mode: LaunchMode, recording: Bool = false, block: () -> Void = {}) {
        app.launchArguments = [mode.rawValue]
        app.launch()
        if recording { pressRecordButtonInControlCenter() }
        block()
        if recording { pressRecordButtonInControlCenter() }
    }

    func openControlCenter(from app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.01))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.2))
        start.press(forDuration: 0.1, thenDragTo: end)
    }

    func closeControlCenter(from app: XCUIApplication) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9)).tap()
    }

    func swipeCell(at index: Int) {
        let cell = cell(at: index)
        let swiper = cell.descendants(matching: .any)["Swiper"]
        let valueLabel = cell.staticTexts.element(boundBy: 1)

        swiper.press(forDuration: 0, thenDragTo: valueLabel)
    }

    func cell(at index: Int) -> XCUIElement {
        app.tables.firstMatch.cells.element(boundBy: index)
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

    private func tapRecordButton() {
        springboard.buttons["Screen Recording"].tap()
    }
}
