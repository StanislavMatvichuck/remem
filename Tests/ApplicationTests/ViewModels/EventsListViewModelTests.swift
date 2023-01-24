//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import Domain
import XCTest

class EventsListViewModelTests: XCTestCase {
    func test_hasNumberOfSections() {
        let root = ApplicationContainer(testingInMemoryMode: true)
        let container = EventsListContainer(applicationContainer: root)
        let sut = container.makeEventsListViewModel(events: [])

        XCTAssertEqual(sut.numberOfSections, 3)
    }
}
