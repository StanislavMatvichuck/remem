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
        let today = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)

        sut = EventItemViewModel(
            event: event,
            today: today,
            hintEnabled: false,
            coordinator: CoordinatorStub(),
            commander: EventsCommandingStub(),
            tapHandler: {}
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
