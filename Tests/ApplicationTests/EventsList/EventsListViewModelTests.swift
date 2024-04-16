//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewModelTests: XCTestCase {
    var sut: EventsListViewModel!
    override func setUp() { super.setUp(); sut = EventsListContainer.makeForUnitTests().makeEventsListViewModel() }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_eventsSortingPresentingButtonText_ordering() { XCTAssertEqual(EventsListViewModel.eventsSortingLabel, "Ordering") }
}
