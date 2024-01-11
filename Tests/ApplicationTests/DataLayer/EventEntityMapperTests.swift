//
//  EventEntityMapperTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 31.05.2023.
//

import CoreData
import DataLayer
import Domain
import XCTest

final class EventEntityMapperTests: XCTestCase {
    private var sut: EventEntityMapper!

    override func setUp() {
        super.setUp()
        sut = EventEntityMapper()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_bidirectionalConversion() {
        let date = DayIndex.referenceValue.date
        let event = Event(
            id: UUID().uuidString,
            name: "Event",
            happenings: [],
            dateCreated: date,
            dateVisited: nil
        )

        assertBidirectionalConversion(event: event)

        event.addHappening(date: date)

        assertBidirectionalConversion(event: event)

        event.setWeeklyGoal(amount: 1, for: date)

        assertBidirectionalConversion(event: event)

        event.setWeeklyGoal(amount: 0, for: date)

        assertBidirectionalConversion(event: event)
    }

    private func assertBidirectionalConversion(event: Event, file: StaticString = #file, line: UInt = #line) {
        let context = CoreDataStack.createContainer(inMemory: true).viewContext
        let cdEvent = CDEvent(context: context)

        sut.update(cdEvent, by: event)

        let recreatedEvent = sut.convert(cdEvent)

        XCTAssertEqual(event, recreatedEvent)
    }
}
