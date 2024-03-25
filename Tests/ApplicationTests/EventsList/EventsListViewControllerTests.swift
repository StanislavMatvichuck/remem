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

    var sut: EventsListController!

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
        XCTAssertNotNil(sut.viewRoot.list.dataSource)
        XCTAssertNotNil(sut.viewRoot.list.delegate)
    }

    // TODO: fix sumbitEvent()
//    func test_singleEvent_swiped_eventAmountIsIncreasedByOne() {
//        submitEvent()
//
//        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "0")
//
//        swipeFirstEvent()
//
//        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "1")
//    }
//
//    func test_singleEvent_swipedTwoTimes_eventAmountIncreasedByTwo() {
//        submitEvent()
//
//        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "0")
//
//        swipeFirstEvent()
//        swipeFirstEvent()
//
//        XCTAssertEqual(sut.viewRoot.eventCell.view.amountContainer.label.text, "2")
//    }
//
//    func test_singleEvent_swiped_showsHint_pressToSeeDetails() {
//        submitEvent()
//        swipeFirstEvent()
//
//        XCTAssertEqual(sut.viewRoot.hintCell.label.text, HintCellViewModel.HintState.pressMe.text)
//    }
//
//    func test_singleEvent_swiped_gestureHintIsNotVisible() {
//        submitEvent()
//        swipeFirstEvent()
//
//        XCTAssertNil(sut.viewRoot.eventCell.view.swipingHint)
//    }

    func test_singleEvent_tapped_showsDetails() {
        // TODO: write this test
    }

    func test_allowsDrag() {
        XCTAssertTrue(sut is UICollectionViewDragDelegate)
        XCTAssertNotNil(sut.viewRoot.list.dragDelegate)
    }

    func test_allowsDrop() {
        XCTAssertTrue(sut is UICollectionViewDropDelegate)
        XCTAssertNotNil(sut.viewRoot.list.dropDelegate)
    }

    func test_configuresEventsSortingButton() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.title, "Ordering")
    }

    func test_allowsDragForEventsOnly() {
        configureWithOneEvent()

        let hintIndex = IndexPath(row: 0, section: EventsListViewModel.Section.hint.rawValue)
        let eventIndex = IndexPath(row: 0, section: EventsListViewModel.Section.events.rawValue)
        let createEventIndex = IndexPath(row: 0, section: EventsListViewModel.Section.createEvent.rawValue)

        XCTAssertEqual(sut.dragItems(hintIndex).count, 0)
        XCTAssertEqual(sut.dragItems(eventIndex).count, 1)
        XCTAssertEqual(sut.dragItems(createEventIndex).count, 0)
    }

    // MARK: - Creation and helpers

    private func configureEmpty() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        sut = container.make() as? EventsListController
        sut.loadViewIfNeeded()
    }

    private func configureWithOneEvent() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.commander.save(event)
        let container = EventsListContainer(appContainer)
        sut = container.make() as? EventsListController
        sut.loadViewIfNeeded()
    }

    private func swipeFirstEvent() { sut.viewRoot.eventCell.viewModel?.swipeHandler() }
}
