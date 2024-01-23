//
//  EventCreationController.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

@testable import Application
import XCTest

final class EventCreationControllerTests: XCTestCase {
    var sut: EventCreationController!

    override func setUp() {
        super.setUp()
        let appContainer = ApplicationContainer(mode: .uikit)
        let container = EventCreationContainer(parent: appContainer)
        sut = EventCreationController(container)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_requiresFactory() { XCTAssertNotNil(sut) }

    func test_presentedInFullScreen() {
        XCTAssertEqual(sut.modalPresentationStyle, .overFullScreen)
        XCTAssertEqual(sut.modalTransitionStyle, .crossDissolve)
    }

    func test_dismissedByTouch() {
        if let view = sut.view as? EventCreationView {
            XCTAssertNotNil(view.gestureRecognizers)
            XCTAssertNotEqual(view.gestureRecognizers?.count, 0)
        } else {
            XCTFail()
        }
    }

    func test_configuresViewModel() {
        guard let view = sut.view as? EventCreationView else { XCTFail(); return }

        XCTAssertNotNil(view.viewModel)
    }

    func test_emojiTap_addsItToName() {
        guard let view = sut.view as? EventCreationView,
              let list = view.subviews[2] as? EmojiView,
              let emoji = list.viewContent.arrangedSubviews.first as? UIButton
        else { XCTFail(); return }

        tap(emoji)

        XCTAssertEqual(view.input.text, emoji.titleLabel?.text)
    }

    func test_keyboardDoneButtonTap_dismissesController() {
        // TODO: finish this test
//        guard let view = sut.view as? EventCreationView else { XCTFail(); return }
//        _ = view.input.delegate?.textFieldShouldReturn?(view.input)
    }

//    func test_submittingEvent_addsEventToList() {
//        submitEvent()
//
//        let eventsAmount = sut.viewRoot.table.numberOfRows(inSection: EventsListViewModel.Section.events.rawValue)
//
//        XCTAssertEqual(eventsAmount, 1)
//    }
}
