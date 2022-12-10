//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import IosUseCases
import ViewControllerPresentationSpy
import XCTest

class EventsListViewControllerTests: XCTestCase {
    // MARK: - Test fixture
    var sut: EventsListViewController!
    var coordinator: Coordinating!

    var table: UITableView { sut.viewRoot.table }
    var view: EventsListView { sut.viewRoot }

    override func setUp() {
        super.setUp()
        (sut, coordinator) = EventsListViewController.make()
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        coordinator = nil
        super.tearDown()
    }

    func test_empty_showsTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_empty_tableIsConfigured() throws {
        XCTAssertNotNil(table.dataSource)
        XCTAssertNotNil(table.delegate)
    }

    func test_empty_tableHasThreeSections() throws {
        XCTAssertEqual(
            table.numberOfSections,
            EventsListViewController.Section.allCases.count
        )
    }

    func test_empty_hasHintSection() {
        XCTAssertEqual(table.numberOfRows(
            inSection: EventsListViewController.Section.hint.rawValue
        ), 1)
    }

    func test_empty_hasFooterSection() {
        XCTAssertEqual(table.numberOfRows(
            inSection: EventsListViewController.Section.footer.rawValue
        ), 1)
    }

    func test_empty_hasNoEventsInList() {
        XCTAssertEqual(table.numberOfRows(
            inSection: EventsListViewController.Section.events.rawValue
        ), 0)
    }

    func test_empty_showsHint_empty() {
        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_empty_gestureHintIsNotVisible() {
        let gestureHint = view.swipeHint

        XCTAssertNil(gestureHint.superview)
    }

    func test_empty_showsHighlightedAddButton() throws {
        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        XCTAssertEqual(sut.addButton.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertTrue(sut.addButton.isHighlighted, "Button must be highlighted when list is empty")
    }

    func test_empty_addButtonTapped_showsKeyboard() throws {
        putInViewHierarchy(sut)

        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        tap(sut.addButton)

        XCTAssertTrue(view.input.textField.isFirstResponder, "keyboard is shown")
    }

    func test_empty_submittingEvent_addsEventToList() {
        sut.submitEvent()

        XCTAssertEqual(sut.eventsCount, 1)
        XCTAssertEqual(sut.firstEvent.nameLabel.text, "SubmittedEventName")
    }

    func test_singleEvent_showsNormalAddButton() throws {
        sut.submitEvent()

        XCTAssertFalse(sut.addButton.isHighlighted)
        XCTAssertEqual(
            sut.addButton.backgroundColor?.cgColor,
            UIHelper.itemBackground.cgColor
        )
    }

    func test_singleEvent_showsHint_firstHappening() {
        sut.submitEvent()

        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.firstHappening"))
    }

    func test_singleEvent_showsOneEvent() {
        sut.submitEvent()

        XCTAssertNotNil(sut.event(at: 0))
    }

    func test_singleEvent_showsGestureHint() {
        sut.submitEvent()

        /// this required to trigger data source methods that mutate the view
        _ = sut.event(at: 0)

        XCTAssertNotNil(sut.viewRoot.swipeHint.superview)
    }

    func test_singleEvent_hasRenameSwipeAction() {
        let renameButton = arrangeFirstEventSwipeAction(number: 1)

        XCTAssertEqual(
            renameButton.title,
            String(localizationId: "button.rename")
        )
    }

    func test_singleEvent_renamePressed_showsKeyboardWithEventName() {
        XCTAssertFalse(view.input.textField.isFirstResponder)

        arrangeFirstEventRenameButtonPressed()

        XCTAssertTrue(view.input.textField.isFirstResponder)
        XCTAssertEqual(view.input.value, "SubmittedEventName")
    }

    func test_singleEvent_submittingRename_changesEventName() throws {
        arrangeFirstEventRenameButtonPressed()

        view.input.value = "ChangedName"

        view.input.textField.delegate?.textFieldShouldReturn?(view.input.textField)

        XCTAssertEqual(sut.firstEvent.nameLabel.text, "ChangedName")
    }

    private func arrangeFirstEventRenameButtonPressed() {
        putInViewHierarchy(sut)
        let renameButton = arrangeFirstEventSwipeAction(number: 1)
        renameButton.handler(renameButton, UIView()) { _ in }
    }

    func test_singleEvent_hasDeleteSwipeAction() {
        let deleteButton = arrangeFirstEventSwipeAction(number: 0)

        XCTAssertEqual(
            deleteButton.title,
            String(localizationId: "button.delete")
        )
    }

    func test_singleEvent_deletePressed_removesEventFromList() throws {
        let deleteButton = arrangeFirstEventSwipeAction(number: 0)

        XCTAssertEqual(sut.eventsCount, 1, "precondition")

        deleteButton.handler(deleteButton, UIView()) { _ in }

        XCTAssertEqual(sut.eventsCount, 0, "precondition")
    }

    func test_singleEvent_swipe_increasesLabelAmountByOne() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()

        sut.arrangeSingleEventSwiped()

        XCTAssertEqual(sut.firstEvent.valueLabel.text, "1")
    }

    func test_singleEvent_swipe_swipe_increasesLabelAmountByTwo() throws {
        let eventCell = sut.arrangeSingleEventSwiped()

        eventCell.swiper.sendActions(for: .primaryActionTriggered)

        XCTAssertEqual(sut.firstEvent.valueLabel.text, "2")
    }

    func test_singleEvent_swipe_showsHint_pressToSeeDetails() {
        sut.arrangeSingleEventSwiped()

        XCTAssertEqual(sut.hintText, String(localizationId: "eventsList.hint.firstVisit"))
    }

    func test_singleEvent_swipe_gestureHintIsNotVisible() {
        sut.arrangeSingleEventSwiped()

        XCTAssertNil(sut.viewRoot.swipeHint.superview)
    }

    func test_singleEvent_eventTapped_opensEventDetails() {
        let navigationController = sut.navigationController

        XCTAssertEqual(navigationController?.viewControllers.count, 1, "precondition")

        sut.submitEvent()

        let indexPath = IndexPath(
            row: 0,
            section: EventsListViewController.Section.events.rawValue
        )
        table.delegate?.tableView?(table, didSelectRowAt: indexPath)

        executeRunLoop()

        XCTAssertEqual(navigationController?.viewControllers.count, 2)
    }

    private func arrangeFirstEventSwipeAction(number: Int) -> UIContextualAction {
        sut.submitEvent()

        let indexPath = IndexPath(
            row: 0,
            section: EventsListViewController.Section.events.rawValue
        )

        let configuration = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: indexPath
        )

        return configuration!.actions[number]
    }
}
