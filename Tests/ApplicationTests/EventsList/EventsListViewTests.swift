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

    override func setUp() {
        super.setUp()
        let controller = EventsListContainer.makeForUnitTests().makeEventsListController()
        controller.loadViewIfNeeded()
        sut = controller.viewRoot
    }

    override func tearDown() { super.tearDown(); sut = nil }

    // MARK: - Tests

    func test_showsHint_addFirstEvent() {
        XCTAssertEqual(sut.hintCell.label.text, String(localizationId: "eventsList.hint.empty"))
    }

    func test_showsCreateEvent_highlighted() {
        XCTAssertEqual(sut.createEventCell.button.titleLabel?.text, CreateEventCellViewModel.title)
        XCTAssertEqual(sut.createEventCell.button.backgroundColor?.cgColor, UIColor.primary.cgColor, "highlighted button has brand background")
    }

    func test_showsNoEvents() {
        let eventsSection = EventsListViewModel.Section.events.rawValue
        XCTAssertEqual(sut.list.dataSource?.collectionView(sut.list, numberOfItemsInSection: eventsSection), 0)
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

    private func firstCellAt(_ section: Int) -> UICollectionViewCell? {
        let indexPath = IndexPath(row: 0, section: section)
        return list.dataSource?.collectionView(list, cellForItemAt: indexPath)
    }
}
