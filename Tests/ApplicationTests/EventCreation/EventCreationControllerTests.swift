//
//  EventCreationController.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

@testable import Application
import XCTest

final class EventCreationControllerTests: XCTestCase {
    func test_init() {
        let sut = EventCreationController()
    }

    func test_presentedInFullScreen() {
        let sut = EventCreationController()

        XCTAssertEqual(sut.modalPresentationStyle, .overFullScreen)
        XCTAssertEqual(sut.modalTransitionStyle, .crossDissolve)
    }

    func test_dismissedByTouch() {
        let sut = EventCreationController()

        if let view = sut.view as? EventCreationView {
            XCTAssertNotNil(view.gestureRecognizers)
            XCTAssertNotEqual(view.gestureRecognizers?.count, 0)
        } else {
            XCTFail()
        }
    }

//    func test_createEventButtonTapped_showsKeyboard() {
//        putInViewHierarchy(sut)
//        XCTAssertFalse(sut.viewRoot.input.inputContainer.field.isFirstResponder, "precondition")
//
//        let footerCell = sut.viewRoot.footerCell
//        tap(footerCell.button)
//
//        XCTAssertTrue(sut.viewRoot.input.inputContainer.field.isFirstResponder, "keyboard is shown")
//    }
//
//    func test_submittingEvent_addsEventToList() {
//        submitEvent()
//
//        let eventsAmount = sut.viewRoot.table.numberOfRows(inSection: EventsListViewModel.Section.events.rawValue)
//
//        XCTAssertEqual(eventsAmount, 1)
//    }
}
