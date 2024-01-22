//
//  EventsSortingExecutorTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsSortingExecutorTests: XCTestCase {
    private var sut: EventsSortingExecutor!

    override func setUp() {
        super.setUp()
        sut = EventsSortingExecutor()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() { XCTAssertNotNil(sut) }

    func test_sort_total() {
        let eventWithoutHappenings = Event(name: "empty")
        let eventWithHappening = Event(name: "oneHappening")
        eventWithHappening.addHappening(date: DayIndex.referenceValue.date)
        let eventsToBeSorted = [eventWithoutHappenings, eventWithHappening]

        let sortedEvents = sut.sort(events: eventsToBeSorted, sorter: .total)

        XCTAssertEqual(sortedEvents.first, eventWithHappening)
    }

    func test_sort_name() {
        let eventA = Event(name: "A")
        let eventB = Event(name: "B")
        let eventsToBeSorted = [eventB, eventA]

        let sortedEvents = sut.sort(events: eventsToBeSorted, sorter: .name)

        XCTAssertEqual(sortedEvents.first, eventA)
    }
}
