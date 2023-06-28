//
//  AppPreview03Recorder.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 17.06.2023.
//

import XCTest

final class AppPreview03Recorder: AppPreviewRecorder {
    let widgetWaitingTime: UInt32 = 11

    func test04_addWeeklyGoal() {
        executeWith(mode: .appPreview02_addWeeklyGoal, recording: recording) {
            /// Open event details
            cell(at: 2).tap()

            /// Add goal
            app.textFields[UITestAccessibilityIdentifier.textFieldGoal.rawValue].tap()
            app.keys["5"].tap()
            app.buttons[UITestAccessibilityIdentifier.buttonGoalDone.rawValue].tap()

            /// Back to list
            app.navigationBars.buttons.firstMatch.tap()

            /// Completing the goal
            swipeCell(at: 2)
            swipeCell(at: 2)
        }
    }

    func test05_widget() {
        executeWith(mode: .appPreview03_widget, recording: recording) {
            XCUIDevice.shared.press(XCUIDevice.Button.home)
            sleep(widgetWaitingTime)
            app.activate()
        }
    }

    func test06_darkMode() {
        executeWith(mode: .appPreview03_darkMode, recording: recording) {
            toggleDarkModeInControlCenter()
            cell(at: 2).tap()
            app.swipeUp()
            app.swipeDown()
        }
    }

    // MARK: - Private
    private func toggleDarkModeInControlCenter() {
        openControlCenter(from: app)
        tapBrightness()
        tapDarkMode()
        closeControlCenter(from: app)
        closeControlCenter(from: app)
    }

    private func tapBrightness() {
        springboard.otherElements["Brightness"].press(forDuration: 2)
    }

    private func tapDarkMode() {
        springboard.buttons["Dark Mode"].tap()
    }
}
