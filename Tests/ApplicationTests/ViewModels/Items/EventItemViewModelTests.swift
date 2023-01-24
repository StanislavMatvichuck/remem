//
//  EventItemViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import Domain
import XCTest

class EventItemViewModelTests: XCTestCase {
    private var sut: EventItemViewModel!

    override func setUp() {
        super.setUp()
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        let root = ApplicationContainer(testingInMemoryMode: true)
        let listContainer = EventsListContainer(applicationContainer: root)
        sut = listContainer.makeEventItemViewModel(
            event: event,
            today: today,
            hintEnabled: false
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }
}
