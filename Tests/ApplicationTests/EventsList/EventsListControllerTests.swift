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

final class EventsListControllerTests: XCTestCase {
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

    func test_showsTitle() { XCTAssertEqual(sut.title, String(localizationId: "eventsList.title")) }
    func test_listIsConfigured() { XCTAssertNotNil(sut.viewRoot.list.dataSource) }

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
        sut = container.makeEventsListController()
        sut.loadViewIfNeeded()
    }

    private func configureWithOneEvent() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.eventsStorage.create(event: event)
        let container = EventsListContainer(appContainer)
        sut = container.makeEventsListController()
        sut.loadViewIfNeeded()
    }
}
