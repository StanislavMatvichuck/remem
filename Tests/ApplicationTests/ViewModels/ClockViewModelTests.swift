//
//  ClockViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 15.12.2023.
//

@testable import Application
import Domain
import XCTest

final class ClockViewModelTests: XCTestCase {
    static let size = 12

    func test_initForDayHappenings_empty_hasSizeCells() {
        let event = Event(name: "")
        let sut = ClockViewModel(withDayHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.count, Self.size)
    }

    // MARK: - InitForDayHappenings

    func test_initForDayHappenings_atStartOfDay_hasFirstCellFullLength() {
        let event = Event(name: "")
        addOneHappening(to: event)
        let sut = ClockViewModel(withDayHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.first?.length, 1)
    }

    func test_initForDayHappenings_beforeMiddleOfDay_hasLastCellWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 11, m: 59, s: 59), to: event)
        let sut = ClockViewModel(withDayHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.last?.length, 1)
    }

    func test_initForDayHappenings_afterMiddleOfDay_hasNoCellsWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0), to: event)
        let sut = ClockViewModel(withDayHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.filter { !$0.isEmpty }.count, 0)
    }

    // MARK: - InitForNightHappenings

    func test_initForNightHappenings_atStartOfNight_hasFirstCellFullLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0), to: event)
        let sut = ClockViewModel(withNightHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.first?.length, 1)
    }

    func test_initForNightHappenings_beforeEndOfNight_hasLastCellWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 23, m: 59, s: 59), to: event)
        let sut = ClockViewModel(withNightHappeningsOf: event, andSize: Self.size)

        XCTAssertEqual(sut.cells.last?.length, 1)
    }

    private func addOneHappening(
        at: TimeComponents = TimeComponents(h: 0, m: 0, s: 0),
        to event: Event
    ) {
        var today = Calendar.current.dateComponents([.hour, .minute, .second], from: .now)
        today.hour = at.h
        today.minute = at.m
        today.second = at.s

        event.addHappening(date: Calendar.current.date(from: today)!)
    }
}
