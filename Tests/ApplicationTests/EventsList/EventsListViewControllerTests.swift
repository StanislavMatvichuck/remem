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
    // MARK: - Setup

    var sut: EventsListViewController!

    override func setUp() {
        super.setUp()
        configureEmpty()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

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

        let footerCell = sut.viewRoot.footerCell
        tap(footerCell.button)

        XCTAssertTrue(sut.viewRoot.input.inputContainer.field.isFirstResponder, "keyboard is shown")
    }

    func test_submittingEvent_addsEventToList() {
        submitEvent()

        let eventsAmount = sut.viewRoot.table.numberOfRows(inSection: EventsListViewModel.Section.events.rawValue)

        XCTAssertEqual(eventsAmount, 1)
    }

    func test_singleEvent_swiped_eventAmountIsIncreasedByOne() {
        submitEvent()

        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "0")

        swipeFirstEvent()

        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "1")
    }

    func test_singleEvent_swipedTwoTimes_eventAmountIncreasedByTwo() {
        submitEvent()

        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "0")

        swipeFirstEvent()
        swipeFirstEvent()

        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "2")
    }

    func test_singleEvent_swiped_showsHint_pressToSeeDetails() {
        submitEvent()
        swipeFirstEvent()

        XCTAssertEqual(sut.viewRoot.hintCell.label.text, HintCellViewModel.HintState.pressMe.text)
    }

    func test_singleEvent_swiped_gestureHintIsNotVisible() {
        submitEvent()
        swipeFirstEvent()

        XCTAssertNil(sut.viewRoot.eventCell.view.swipingHint)
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

    // MARK: - Creation and helpers

    private func configureEmpty() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        sut = container.make() as? EventsListViewController
        sut.loadViewIfNeeded()
    }

    private func submitEvent() {
        let input = sut.viewRoot.input
        input.value = "SubmittedEventName"

        _ = input.inputContainer.field.delegate?.textFieldShouldReturn?(
            input.inputContainer.field
        )
    }

    private func swipeFirstEvent() { sut.viewRoot.eventCell.viewModel?.swipeHandler() }
}
