//
//  EventsListViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 15.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewTests: XCTestCase {
    func test_init() { _ = EventsListView() }

    func test_showsHint_addFirstEvent() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let indexPath = IndexPath(row: 0, section: 0) // too attached to implementation?
        let table = sut.table
        guard
            let hintCell = table.dataSource?.tableView(table, cellForRowAt: indexPath)
            as? HintCell
        else { fatalError() }

        XCTAssertEqual(hintCell.label.text, HintCellViewModel.HintState.addFirstEvent.text)
    }

    func test_showsCreateEvent_highlighted() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let indexPath = IndexPath(row: 0, section: 2) // too attached to implementation?
        let table = sut.table
        guard
            let footerCell = table.dataSource?.tableView(table, cellForRowAt: indexPath)
            as? FooterCell
        else { fatalError() }

        XCTAssertEqual(footerCell.button.titleLabel?.text, FooterCellViewModel.title)
        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIColor.primary.cgColor, "highlighted button has brand background")
    }

    func test_showsNoEvents() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let table = sut.table

        XCTAssertEqual(table.dataSource?.tableView(table, numberOfRowsInSection: 1), 0)
    }

    func test_oneEvent_showsEvent_withHintCell() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)

        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.commander.save(event)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let indexPath = IndexPath(row: 0, section: 1) // too attached to implementation?
        let table = sut.table
        guard
            let eventCell = table.dataSource?.tableView(table, cellForRowAt: indexPath) as? EventCell
        else { fatalError() }

        XCTAssertNotNil(eventCell.view.swipingHint)
    }

    func test_oneEvent_hintAsksToSwipeEvent() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)

        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.commander.save(event)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let indexPath = IndexPath(row: 0, section: 0) // too attached to implementation?
        let table = sut.table
        guard
            let hintCell = table.dataSource?.tableView(table, cellForRowAt: indexPath) as? HintCell
        else { fatalError() }

        XCTAssertEqual(hintCell.label.text, HintCellViewModel.HintState.swipeFirstTime.text)
    }

    func test_oneEvent_showsCreateEvent_default() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.commander.save(event)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel(nil)
        let sut = EventsListView()
        sut.viewModel = viewModel
        let indexPath = IndexPath(row: 0, section: 2) // too attached to implementation?
        let table = sut.table
        guard
            let footerCell = table.dataSource?.tableView(table, cellForRowAt: indexPath)
            as? FooterCell
        else { fatalError() }

        XCTAssertEqual(footerCell.button.backgroundColor?.cgColor, UIColor.bg_item.cgColor, "highlighted button has brand background")
    }
}
