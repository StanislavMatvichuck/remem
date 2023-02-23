//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewControllerTests: XCTestCase, TestingViewController {
    var sut: EventsListViewController!
    var commander: EventsCommanding!
    var event: Event!

    var table: UITableView { sut.viewRoot.table }
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
        let index = IndexPath(row: 0, section: 0)
        let hintCell = table.dataSource?.tableView(table, cellForRowAt: index) as! HintItem
        XCTAssertEqual(hintCell.label.text, HintState.empty.text)
    }

    func test_showsAddEventButton() {
        let index = IndexPath(row: 1, section: 0)
        let footerCell = table.dataSource?.tableView(table, cellForRowAt: index) as! FooterItem
        XCTAssertEqual(footerCell.button.titleLabel?.text, String(localizationId: "button.create"))
    }

    func test_empty_hasNoEvents() {
        XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
    }

    func test_empty_showsHint_empty() {
        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_empty_showsCreateEventButton_highlighted() {
        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIHelper.colorButtonTextHighLighted,
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        let footerCell = table.dataSource?.tableView(
            table,
            cellForRowAt: IndexPath(
                row: 1,
                section: 0
            )
        ) as! FooterItem

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "button text is white with proper font")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIHelper.brand.cgColor, "highlighted button has brand background")
    }

    func test_createEventButtonTapped_showsKeyboard() {
        putInViewHierarchy(sut)
        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        let footerCell = table.dataSource?.tableView(
            table,
            cellForRowAt: IndexPath(
                row: 1,
                section: 0
            )
        ) as! FooterItem

        tap(footerCell.button)

        XCTAssertTrue(view.input.textField.isFirstResponder, "keyboard is shown")
    }

    func test_submittingEvent_addsEventToList() {
        submitEvent()

        XCTAssertEqual(eventsCount, 1)
        XCTAssertEqual(firstEvent.nameLabel.text, "SubmittedEventName")
    }

    func test_singleEvent_showsCreateButton_default() {
        submitEvent()

        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIHelper.colorButtonText,
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        let footerCell = table.dataSource?.tableView(
            table,
            cellForRowAt: IndexPath(
                row: 2,
                section: 0
            )
        ) as! FooterItem

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIHelper.itemBackground.cgColor, "button has regular background")
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
        /// is it part of list controller or EventItemViewModel?
        /// should some tests be moved to EventItemViewModel?
        submitEvent()

        XCTAssertNotNil(firstEvent.viewRoot.swipingHint)
    }

    func test_singleEvent_hasRenameSwipeAction() {
        /// is it part of list controller or EventItemViewModel?
        /// should some tests be moved to EventItemViewModel?
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

        XCTAssertEqual(firstEvent.nameLabel.text, "ChangedName")
    }

    func test_singleEvent_deletePressed_removesEventFromList() {
        let button = submittedEventTrailingSwipeActionButton(number: 1)

        XCTAssertEqual(eventsCount, 1, "precondition")

        button.handler(button, UIView()) { _ in }

        XCTAssertEqual(eventsCount, 0)
    }

    // TODO: refactor tests to use string identifiers instead of indexPath
//    func test_singleEvent_swiped_eventAmountIsIncreasedByOne() {
//        sut.arrangeSingleEventSwiped()
//
//        XCTAssertEqual(sut.firstEvent.valueLabel.text, "1")
//    }
//
//    func test_singleEvent_swipedTwoTimes_eventAmountIncreasedByTwo() {
//        sut.arrangeSingleEventSwiped()
//        sut.swipeFirstEvent()
//
//        XCTAssertEqual(sut.firstEvent.valueLabel.text, "2")
//    }
//
//    func test_singleEvent_swiped_showsHint_pressToSeeDetails() {
//        sut.arrangeSingleEventSwiped()
//
//        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.firstVisit"))
//    }
//
//    func test_singleEvent_swiped_gestureHintIsNotVisible() {
//        sut.arrangeSingleEventSwiped()
//
//        let event = sut.firstEvent
//
//        XCTAssertNil(event.viewRoot.swipingHint)
//    }
}
