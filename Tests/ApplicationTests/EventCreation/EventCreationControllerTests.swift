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

    func test_configuresViewModel() {
        let sut = EventCreationController()

        guard let view = sut.view as? EventCreationView else { XCTFail(); return }

        XCTAssertNotNil(view.viewModel)
    }

    func test_emojiTap_addsItToName() {
        let sut = EventCreationController()

        guard let view = sut.view as? EventCreationView,
              let list = view.subviews[2] as? EmojiView,
              let emoji = list.viewContent.arrangedSubviews.first as? UIButton
        else { XCTFail(); return }

        tap(emoji)

        XCTAssertEqual(view.input.text, emoji.titleLabel?.text)
    }

//    func test_submittingEvent_addsEventToList() {
//        submitEvent()
//
//        let eventsAmount = sut.viewRoot.table.numberOfRows(inSection: EventsListViewModel.Section.events.rawValue)
//
//        XCTAssertEqual(eventsAmount, 1)
//    }
}
