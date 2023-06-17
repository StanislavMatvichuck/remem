//
//  ApplicationUITests.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 31.01.2023.
//

import XCTest

final class AppPreview02Recorder: AppPreviewRecorder {
    var firstEventCell: XCUIElement! { cell(at: 0) }
    var footer: XCUIElement! { app.tables.firstMatch.cells["FooterCell"].firstMatch }
    var field: XCUIElement! { app.textFields.element }

    func test01_addingEvents() {
        executeWith(mode: .appPreview02_addingEvents, recording: recording) {
            footer.tap()
            submitFirstEvent()

            footer.tap()
            submitSecondEvent()

            footer.tap()
            submitThirdEvent()
        }
    }

    func test02_swipingEvents() {
        executeWith(mode: .appPreview02_swipingEvents, recording: recording) {
            swipeCell(at: 0)
            swipeCell(at: 1)
            swipeCell(at: 2)

            swipeCell(at: 2)
            swipeCell(at: 1)
            swipeCell(at: 2)
        }
    }

    func test03_viewDetailsAndExport() {
        executeWith(mode: .appPreview02_viewDetailsAndExport, recording: recording) {
            /// Open event details
            cell(at: 1).tap()
            app.collectionViews.firstMatch.swipeRight()
            app.collectionViews.firstMatch.swipeLeft()
            app.scrollViews[UITestAccessibilityIdentifier.eventDetailsScroll.rawValue].swipeUp()

            /// Open pdf report
            app.buttons[UITestAccessibilityIdentifier.buttonPdfCreate.rawValue].tap()
            app.buttons[UITestAccessibilityIdentifier.buttonPdfShare.rawValue].tap()

            /// Open mail share modal
            app.cells["Mail"].tap()
            app.textFields["toField"].tap()
            app.textFields["toField"].typeText("someEmail@gmail.com")
            app.textViews["subjectField"].tap()
            app.textViews["subjectField"].typeText("Coffee drinking report")

            /// Close mail share modal
            app.buttons["Mail.sendButton"].tap()
        }
    }

    // MARK: - Private
    private func weekCell(at index: Int) -> XCUIElement {
        app.collectionViews.firstMatch.cells.element(boundBy: index)
    }

    private func submitSecondEvent() {
        field.typeText("Coffee ")

        let coffeeEmoji = app.buttons["☕️"]
        coffeeEmoji.tap()

        app.keyboards.buttons["Done"].tap()
    }

    private func submitThirdEvent() {
        field.typeText("Fitness ")

        let coffeeEmoji = app.buttons["👟"]
        coffeeEmoji.tap()

        app.keyboards.buttons["Done"].tap()
    }

    private func submitFirstEvent() {
        field.typeText("Car broke down 🚙")
        app.keyboards.buttons["Done"].tap()
    }
}
