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
    // MARK: - Setup

    private var sut: EventsListView!
    private var container: EventsListContainer!

    override func setUp() {
        super.setUp()
        configureEmptySutAndContainer()
    }

    override func tearDown() {
        sut = nil
        container = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_init() { _ = EventsListView() }

    func test_showsHint_addFirstEvent() {
        XCTAssertEqual(sut.hintCell.label.text, HintCellViewModel.HintState.addFirstEvent.text)
    }

    func test_showsCreateEvent_highlighted() {
        XCTAssertEqual(sut.createEventCell.button.titleLabel?.text, CreateEventCellViewModel.title)
        XCTAssertEqual(sut.createEventCell.button.backgroundColor?.cgColor, UIColor.primary.cgColor, "highlighted button has brand background")
    }

    func test_showsNoEvents() {
        XCTAssertEqual(sut.table.dataSource?.tableView(sut.table, numberOfRowsInSection: 1), 0)
    }

    func test_oneEvent_showsEvent_withHintCell() {
        configureWithOneEvent()

        XCTAssertNotNil(sut.eventCell.view.swipingHint)
    }

    func test_oneEvent_hintAsksToSwipeEvent() {
        configureWithOneEvent()

        XCTAssertEqual(sut.hintCell.label.text, HintCellViewModel.HintState.swipeFirstTime.text)
    }

    func test_oneEvent_showsCreateEvent_default() {
        configureWithOneEvent()

        XCTAssertEqual(sut.createEventCell.button.backgroundColor?.cgColor, UIColor.bg_item.cgColor, "highlighted button has brand background")
    }

    // MARK: - Creation

    private func configureEmptySutAndContainer() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appContainer)
        let viewModel = container.makeEventsListViewModel()
        let sut = EventsListView()
        sut.viewModel = viewModel

        self.sut = sut
        self.container = container
    }

    private func configureWithOneEvent() {
        container.commander.save(Event(name: "", dateCreated: DayIndex.referenceValue.date))
        sut.viewModel = container.makeEventsListViewModel()
    }
}

// MARK: - Cells getting
/// Used by `EventsListViewTests` and `EventsListViewControllerTests`
extension EventsListView {
    var hintCell: HintCell {
        let section = EventsListViewModel.Section.hint.rawValue
        if let cell = firstCellAt(section) as? HintCell { return cell }
        else { fatalError("unable to get cell of requested type") }
    }

    var eventCell: EventCell {
        let section = EventsListViewModel.Section.events.rawValue
        if let cell = firstCellAt(section) as? EventCell { return cell }
        else { fatalError("unable to get cell of requested type") }
    }

    var createEventCell: CreateEventCell {
        let section = EventsListViewModel.Section.createEvent.rawValue
        if let cell = firstCellAt(section) as? CreateEventCell { return cell }
        else { fatalError("unable to get cell of requested type") }
    }

    private func firstCellAt(_ section: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: 0, section: section)
        return table.dataSource?.tableView(table, cellForRowAt: indexPath)
    }
}
