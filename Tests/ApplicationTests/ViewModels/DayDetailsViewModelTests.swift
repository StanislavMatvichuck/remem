//
//  DayDetailsViewModelTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

class DayDetailsViewModelTests: XCTestCase {
    func test_eventWithNoHappenings_showsNothing() {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        let sut = DayViewModel(day: day, event: event)

        XCTAssertEqual(sut.items.count, 0)
    }
 
    func test_eventWithHappeningAtSameDay_showsHappening() {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        event.addHappening(date: day.date.addingTimeInterval(60 * 60))
        let sut = DayViewModel(day: day, event: event)

        XCTAssertEqual(sut.items.count, 1)
    }

    func test_eventWithHappeningAtAnotherDay_showsNothing() {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        event.addHappening(date: day.date.addingTimeInterval(60 * 60 * 24))
        let sut = DayViewModel(day: day, event: event)

        XCTAssertEqual(sut.items.count, 0)
    }
}
