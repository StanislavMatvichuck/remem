//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewControllerTests: XCTestCase, EventsListViewControllerTesting {
    // MARK: - Test fixture
    var sut: EventsListViewController!
    var viewModelFactory: EventsListViewModelFactoring!
    var table: UITableView { sut.viewRoot.table }
    var view: EventsListView { sut.viewRoot }

    override func setUp() {
        super.setUp()
        makeSutWithViewModelFactory()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        clearSutAndViewModelFactory()
        executeRunLoop()
        super.tearDown()
    }

    func test_showsTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_tableIsConfigured() {
        XCTAssertNotNil(table.dataSource)
        XCTAssertNotNil(table.delegate)
    }

    func test_tableHasThreeSections() {
        XCTAssertEqual(table.numberOfSections, 3)
    }

    func test_showsHint() {
        let index = IndexPath(row: 0, section: 0)
        let hintCell = table.dataSource?.tableView(table, cellForRowAt: index) as! HintItem
        XCTAssertEqual(hintCell.label.text, HintState.empty.text)
    }

    func test_showsAddEventButton() {
        let index = IndexPath(row: 0, section: 2)
        let footerCell = table.dataSource?.tableView(table, cellForRowAt: index) as! FooterItem
        XCTAssertEqual(footerCell.button.titleLabel?.text, String(localizationId: "button.create"))
    }

    func test_empty_hasNoEventsInList() {
        XCTAssertEqual(table.numberOfRows(inSection: 1), 0)
    }

    func test_empty_showsHint_empty() {
        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_empty_showsHighlightedAddButton() throws {
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
                row: 0,
                section: 2
            )
        ) as! FooterItem

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "button text is white with proper font")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIHelper.brand.cgColor, "highlighted button has brand background")
    }

    func test_empty_addButtonTapped_showsKeyboard() {
        putInViewHierarchy(sut)
        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        let footerCell = table.dataSource?.tableView(
            table,
            cellForRowAt: IndexPath(
                row: 0,
                section: 2
            )
        ) as! FooterItem

        tap(footerCell.button)

        XCTAssertTrue(view.input.textField.isFirstResponder, "keyboard is shown")
    }

    func test_empty_submittingEvent_addsEventToList() {
        sut.submitEvent()

        XCTAssertEqual(sut.eventsCount, 1)
        XCTAssertEqual(sut.firstEvent.nameLabel.text, "SubmittedEventName")
    }

    func test_singleEvent_showsNormalAddButton() {
        sut.submitEvent()

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
                row: 0,
                section: 2
            )
        ) as! FooterItem

        XCTAssertEqual(footerCell.button.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIHelper.itemBackground.cgColor, "button has regular background")
    }

    func test_singleEvent_showsHint_firstHappening() {
        sut.submitEvent()

        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.firstHappening"))
    }

    func test_singleEvent_showsOneEvent() {
        sut.submitEvent()

        XCTAssertNotNil(sut.firstEvent)
    }

    func test_singleEvent_showsGestureHint() {
        sut.submitEvent()

        let event = sut.firstEvent

        XCTAssertNotNil(event.viewRoot.swipingHint)
    }

    func test_singleEvent_hasRenameSwipeAction() {
        let button = sut.submittedEventTrailingSwipeActionButton(number: 0)

        XCTAssertEqual(
            button.title,
            String(localizationId: "button.rename")
        )
    }

    func test_singleEvent_hasDeleteSwipeAction() {
        let button = sut.submittedEventTrailingSwipeActionButton(number: 1)

        XCTAssertEqual(
            button.title,
            String(localizationId: "button.delete")
        )
    }

    func test_singleEvent_renamePressed_showsKeyboardWithEventName() {
        putInViewHierarchy(sut)
        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        let button = sut.submittedEventTrailingSwipeActionButton(number: 0)

        button.handler(button, UIView()) { _ in }

        XCTAssertTrue(view.input.textField.isFirstResponder)
        XCTAssertEqual(view.input.value, "SubmittedEventName")
    }

    func test_singleEvent_submittingRename_changesEventName() {
        let button = sut.submittedEventTrailingSwipeActionButton(number: 0)

        button.handler(button, UIView()) { _ in }
        view.input.value = "ChangedName"
        _ = view.input.textField.delegate?.textFieldShouldReturn?(view.input.textField)

        XCTAssertEqual(sut.firstEvent.nameLabel.text, "ChangedName")
    }

    func test_singleEvent_deletePressed_removesEventFromList() {
        let button = sut.submittedEventTrailingSwipeActionButton(number: 1)

        XCTAssertEqual(sut.eventsCount, 1, "precondition")

        button.handler(button, UIView()) { _ in }

        XCTAssertEqual(sut.eventsCount, 0)
    }

    func test_singleEvent_swipe_increasesLabelAmountByOne() {
        sut.arrangeSingleEventSwiped()

        XCTAssertEqual(sut.firstEvent.valueLabel.text, "1")
    }

    func test_singleEvent_swipe_swipe_increasesLabelAmountByTwo() {
        sut.arrangeSingleEventSwiped()
        sut.swipeFirstEvent()

        XCTAssertEqual(sut.firstEvent.valueLabel.text, "2")
    }

    func test_singleEvent_swipe_showsHint_pressToSeeDetails() {
        sut.arrangeSingleEventSwiped()

        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.firstVisit"))
    }

    func test_singleEvent_swipe_gestureHintIsNotVisible() {
        sut.arrangeSingleEventSwiped()

        let event = sut.firstEvent

        XCTAssertNil(event.viewRoot.swipingHint)
    }
}
