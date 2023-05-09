//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

final class EventsListViewControllerTests: XCTestCase, TestingViewController {
    var sut: EventsListViewController!
    var commander: EventsCommanding!
    var event: Event!

    var view: EventsListView { sut.viewRoot }

    override func setUp() {
        super.setUp()
        make()
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_showsTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_tableIsConfigured() {
        XCTAssertNotNil(table.dataSource)
        XCTAssertNotNil(table.delegate)
    }

    func test_showsHint() {
        let hintCell = cell(0) as! HintCell

        XCTAssertEqual(hintCell.label.text, HintState.empty.text)
    }

    func test_showsAddEventButton() {
        let footerCell = cell(1) as! FooterCell

        XCTAssertEqual(footerCell.button.titleLabel?.text, String(localizationId: "button.create"))
    }

    func test_empty_hasNoEvents() {
        XCTAssertEqual(eventsCount, 0)
    }

    func test_empty_showsHint_empty() {
        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_empty_showsCreateEventButton_highlighted() {
        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.text_secondary,
                NSAttributedString.Key.font: UIFont.fontSmallBold,
            ]
        )

        let footerCell = cell(1) as! FooterCell

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "button text is white with proper font")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIColor.primary.cgColor, "highlighted button has brand background")
    }

    func test_createEventButtonTapped_showsKeyboard() {
        putInViewHierarchy(sut)
        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        let footerCell = cell(1) as! FooterCell

        tap(footerCell.button)

        XCTAssertTrue(view.input.textField.isFirstResponder, "keyboard is shown")
    }

    func test_submittingEvent_addsEventToList() {
        submitEvent()

        XCTAssertEqual(eventsCount, 1)
        XCTAssertEqual(firstEvent.view.title.text, "SubmittedEventName")
    }

    func test_singleEvent_showsCreateButton_default() {
        submitEvent()

        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.primary,
                NSAttributedString.Key.font: UIFont.fontSmallBold,
            ]
        )

        let footerCell = cell(2) as! FooterCell

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIColor.background_secondary.cgColor, "button has regular background")
    }

    func test_singleEvent_showsHint_firstHappening() {
        submitEvent()

        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.firstHappening"))
    }

    func test_singleEvent_showsOneEvent() {
        submitEvent()

        XCTAssertNotNil(firstEvent)
    }

    func test_singleEvent_showsGestureHint() {
        submitEvent()
        XCTAssertNotNil(firstEvent.view.swipingHint)
    }

    func test_singleEvent_hasRenameSwipeAction() {
        let button = submittedEventTrailingSwipeActionButton(number: 0)

        XCTAssertEqual(
            button.title,
            String(localizationId: "button.rename")
        )
    }

    func test_singleEvent_hasDeleteSwipeAction() {
        let button = submittedEventTrailingSwipeActionButton(number: 1)

        XCTAssertEqual(
            button.title,
            String(localizationId: "button.delete")
        )
    }

    func test_singleEvent_renamePressed_showsKeyboardWithEventName() {
        putInViewHierarchy(sut)
        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        let button = submittedEventTrailingSwipeActionButton(number: 0)

        button.handler(button, UIView()) { _ in }

        XCTAssertTrue(view.input.textField.isFirstResponder)
        XCTAssertEqual(view.input.value, "SubmittedEventName")
    }

    func test_singleEvent_submittingRename_eventNameUpdated() {
        let button = submittedEventTrailingSwipeActionButton(number: 0)

        button.handler(button, UIView()) { _ in }
        view.input.value = "ChangedName"
        _ = view.input.textField.delegate?.textFieldShouldReturn?(view.input.textField)

        XCTAssertEqual(firstEvent.view.title.text, "ChangedName")
    }

    func test_singleEvent_deletePressed_removesEventFromList() {
        let button = submittedEventTrailingSwipeActionButton(number: 1)

        XCTAssertEqual(eventsCount, 1, "precondition")

        button.handler(button, UIView()) { _ in }

        XCTAssertEqual(eventsCount, 0)
    }

    func test_singleEvent_swiped_eventAmountIsIncreasedByOne() {
        submitEvent()

        XCTAssertEqual(firstEvent.view.amountContainer.label.text, "0")

        swipeFirstEvent()

        XCTAssertEqual(firstEvent.view.amountContainer.label.text, "1")
    }

    func test_singleEvent_swipedTwoTimes_eventAmountIncreasedByTwo() {
        submitEvent()

        XCTAssertEqual(firstEvent.view.amountContainer.label.text, "0")

        swipeFirstEvent()
        swipeFirstEvent()

        XCTAssertEqual(firstEvent.view.amountContainer.label.text, "2")
    }

    func test_singleEvent_swiped_showsHint_pressToSeeDetails() {
        arrangeSingleEventSwiped()

        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.firstVisit"))
    }

    func test_singleEvent_swiped_gestureHintIsNotVisible() {
        arrangeSingleEventSwiped()

        XCTAssertNil(firstEvent.view.swipingHint)
    }

    func test_singleEvent_tapped_showsDetails() {
        // TODO: write this test
    }
}
