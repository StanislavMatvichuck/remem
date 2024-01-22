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

    func test_sort_manual() {
        let eventA = Event(name: "A")
        let eventB = Event(name: "B")
        let eventsToBeSorted = [eventB, eventA]
        let eventsManualIdentifiers = [eventA.id, eventB.id]

        let sortedEvents = sut.sort(
            events: eventsToBeSorted,
            sorter: .manual,
            manualIdentifiers: eventsManualIdentifiers
        )

        XCTAssertEqual(sortedEvents.first, eventA)
    }

    func test_sort_manual_removedEventIsIgnored() {
        let eventA = Event(name: "A")
        let eventB = Event(name: "B")
        let eventC = Event(name: "C")

        let eventsToBeSorted = [eventC, eventB]
        let eventsManualIdentifiers = [eventA.id, eventB.id, eventC.id]

        let sortedEvents = sut.sort(
            events: eventsToBeSorted,
            sorter: .manual,
            manualIdentifiers: eventsManualIdentifiers
        )

        XCTAssertEqual(sortedEvents.first, eventB)
    }

    func test_sort_manual_newEventIsAddedToEnd() {
        let eventA = Event(name: "A")
        let eventB = Event(name: "B")
        let eventC = Event(name: "C")

        let eventsToBeSorted = [eventB, eventA, eventC]
        let eventsManualIdentifiers = [eventA.id, eventB.id]

        let sortedEvents = sut.sort(
            events: eventsToBeSorted,
            sorter: .manual,
            manualIdentifiers: eventsManualIdentifiers
        )

        XCTAssertEqual(sortedEvents.first, eventA)
        XCTAssertEqual(sortedEvents.last, eventC)
    }
}
