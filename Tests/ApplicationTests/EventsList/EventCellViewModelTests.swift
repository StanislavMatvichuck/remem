//
//  EventItemViewModelTests.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.04.2023.
//

@testable import Application
import Domain
import XCTest

final class EventCellViewModelTests: XCTestCase {
    func test_TimeSinceDate() {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(year: 2022, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        let date = calendar.date(from: dateComponents)!

        var now = calendar.date(byAdding: .minute, value: 1, to: date)!
        var timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 minute")

        now = calendar.date(byAdding: .hour, value: 1, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 hour")

        now = calendar.date(byAdding: .hour, value: 12, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "12 hours")

        now = calendar.date(byAdding: .hour, value: 23, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "23 hours")

        now = calendar.date(byAdding: .hour, value: 25, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 day, 1 hour")

        now = calendar.date(byAdding: .day, value: 1, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 day")

        now = calendar.date(byAdding: .day, value: 6, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "6 days")

        now = calendar.date(byAdding: .day, value: 7, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 week")

        now = calendar.date(byAdding: .day, value: 11, to: date)!
        timeString = EventCellViewModel.timeSinceDate(date: date, now: now)

        XCTAssertEqual(timeString, "1 week, 4 days")
    }

    func test_isValueIncreased_trueAfterHappeningAddition() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)

        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(event)

        let container = EventsListContainer(appC)
        let oldValue = container.makeEventItemViewModel(event: event, hintEnabled: true, renameHandler: nil)

        event.addHappening(date: DayIndex.referenceValue.date)
        appC.commander.save(event)

        let sut = container.makeEventItemViewModel(event: event, hintEnabled: false, renameHandler: nil)

        XCTAssertTrue(sut.isValueIncreased(oldValue))
    }
}
