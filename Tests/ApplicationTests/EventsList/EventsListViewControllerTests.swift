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

final class EventsListViewControllerTests: XCTestCase {
    var sut: EventsListViewController!
    var commander: EventsCommanding!

    override func setUp() {
        super.setUp()
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        sut = container.make() as? EventsListViewController
        commander = appContainer.commander
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        commander = nil
        super.tearDown()
    }

    func test_showsTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_tableIsConfigured() {
        XCTAssertNotNil(sut.viewRoot.table.dataSource)
        XCTAssertNotNil(sut.viewRoot.table.delegate)
    }

    func test_createEventButtonTapped_showsKeyboard() {
        putInViewHierarchy(sut)
        XCTAssertFalse(sut.viewRoot.input.inputContainer.field.isFirstResponder, "precondition")

        let index = IndexPath(row: 0, section: 2)
        let table = sut.viewRoot.table
        guard let footerCell = table.dataSource?.tableView(
            table,
            cellForRowAt: index
        ) as? FooterCell else { return XCTFail() }

        tap(footerCell.button)

        XCTAssertTrue(sut.viewRoot.input.inputContainer.field.isFirstResponder, "keyboard is shown")
    }

    func test_submittingEvent_addsEventToList() {
        submitEvent()

        let eventsAmount = sut.viewRoot.table.numberOfRows(inSection: EventsListViewModel.Section.events.rawValue)

        XCTAssertEqual(eventsAmount, 1)
    }

    var firstEventCell: EventCell {
        let index = IndexPath(row: 0, section: 1)
        let table = sut.viewRoot.table

        return table.dataSource?.tableView(
            table,
            cellForRowAt: index
        ) as! EventCell
    }

    func test_singleEvent_swiped_eventAmountIsIncreasedByOne() {
        submitEvent()

        XCTAssertEqual(firstEventCell.view.amountContainer.label.text, "0")

        swipeFirstEvent()

        XCTAssertEqual(firstEventCell.view.amountContainer.label.text, "1")
    }

    func test_singleEvent_swipedTwoTimes_eventAmountIncreasedByTwo() {
        submitEvent()

        XCTAssertEqual(firstEventCell.view.amountContainer.label.text, "0")

        swipeFirstEvent()
        swipeFirstEvent()

        XCTAssertEqual(firstEventCell.view.amountContainer.label.text, "2")
    }

    func test_singleEvent_swiped_showsHint_pressToSeeDetails() {
        submitEvent()
        swipeFirstEvent()

        let index = IndexPath(row: 0, section: EventsListViewModel.Section.hint.rawValue)
        let table = sut.viewRoot.table
        guard
            let hintCell = table.dataSource?.tableView(table, cellForRowAt: index)
            as? HintCell
        else { return XCTFail() }
        
        XCTAssertEqual(hintCell.label.text, HintCellViewModel.HintState.pressMe.text)
    }

    func test_singleEvent_swiped_gestureHintIsNotVisible() {
        submitEvent()
        swipeFirstEvent()
        
        XCTAssertNil(firstEventCell.view.swipingHint)
    }

    func test_singleEvent_tapped_showsDetails() {
        // TODO: write this test
    }

    func test_allowsEventsDrag() {
        XCTAssertTrue(sut is UITableViewDragDelegate)
        XCTAssertNotNil(sut.viewRoot.table.dragDelegate)
    }

    func test_allowsItemsDrop() {
        XCTAssertTrue(sut is UITableViewDropDelegate)
        XCTAssertNotNil(sut.viewRoot.table.dropDelegate)
    }

    private func submitEvent() {
        let input = sut.viewRoot.input
        input.value = "SubmittedEventName"

        _ = input.inputContainer.field.delegate?.textFieldShouldReturn?(
            input.inputContainer.field
        )
    }

    func swipeFirstEvent() {
        if let cell = (sut.viewModel?.cells(for: .events) as? [EventCellViewModel])?.first {
            cell.swipeHandler()
        }
    }
}

struct EventsCommandingStub: EventsCommanding {
    func save(_: Event) {}
    func delete(_: Event) {}
}
