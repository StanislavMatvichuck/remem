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
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        XCTAssertEqual(sut.cells.count, Self.size)
    }

    func test_initForDayHappenings_empty_allSectionsAreEmpty() {
        let event = Event(name: "")
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)
        let notEmptySections = sut.cells.filter { !$0.isEmpty }

        XCTAssertEqual(notEmptySections.count, 0)
    }

    // MARK: - InitForDayHappenings

    func test_initForDayHappenings_atStartOfDay_hasFirstCellFullLength() {
        let event = Event(name: "")
        addOneHappening(to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        XCTAssertEqual(sut.cells.first?.length, 1)
    }

    func test_initForDayHappenings_beforeMiddleOfDay_hasLastCellWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 11, m: 59, s: 59), to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        XCTAssertEqual(sut.cells.last?.length, 1)
    }

    func test_initForDayHappenings_afterMiddleOfDay_hasNoCellsWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0), to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        XCTAssertEqual(sut.cells.filter { !$0.isEmpty }.count, 0)
    }

    // MARK: - InitForNightHappenings

    func test_initForNightHappenings_atStartOfNight_hasFirstCellFullLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0), to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .night)

        XCTAssertEqual(sut.cells.first?.length, 1)
    }

    func test_initForNightHappenings_beforeEndOfNight_hasLastCellWithLength() {
        let event = Event(name: "")
        addOneHappening(at: TimeComponents(h: 23, m: 59, s: 59), to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .night)

        XCTAssertEqual(sut.cells.last?.length, 1)
    }

    func test_initForDayHappenings_manyHappenings_atOneTime_oneSectionIsNotEmpty() {
        let event = Event(name: "")
        addOneHappening(to: event)
        addOneHappening(to: event)
        addOneHappening(to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)
        let notEmptySections = sut.cells.filter { !$0.isEmpty }

        XCTAssertEqual(notEmptySections.count, 1)
    }

    func test_initForDayHappenings_manyHappenings_atTwoTimes_twoSectionsHaveEqualSize() {
        let time = TimeComponents(h: 10, m: 30, s: 45)
        let time02 = TimeComponents(h: 11, m: 35, s: 45)

        let event = Event(name: "")
        addOneHappening(at: time, to: event)
        addOneHappening(at: time02, to: event)
        let sut = ClockViewModel(event: event, size: Self.size, type: .day)
        let notEmptySections = sut.cells.filter { !$0.isEmpty }

        XCTAssertEqual(notEmptySections.count, 2, "precondition")
        XCTAssertEqual(
            sut.cells[0].length,
            sut.cells[1].length
        )
    }

    /// also make snapshots for these cases
    func test_manyHappenings_moreAtExactHour_hourSectionsAreBigger() {}
    func test_initForDayHappenings_manyHappenings_evenlyDistributed_allSectionsHaveFullSize() {
        let event = Event(name: "")

        for h in 0 ..< 24 {
            for m in 0 ..< 60 {
                addOneHappening(at: TimeComponents(h: h, m: m, s: 0), to: event)
            }
        }

        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        for cell in sut.cells {
            XCTAssertEqual(cell.length, 1)
        }
    }

    func test_initForNightHappenings_manyHappenings_evenlyDistributed_allSectionsHaveFullSize() {
        let event = Event(name: "")

        for h in 0 ..< 24 {
            for m in 0 ..< 60 {
                addOneHappening(at: TimeComponents(h: h, m: m, s: 0), to: event)
            }
        }

        let sut = ClockViewModel(event: event, size: Self.size, type: .night)

        for cell in sut.cells {
            XCTAssertEqual(cell.length, 1)
        }
    }

    // TODO: Breaks after clock is divided by day and night types
    func test_manyHappenings_randomlyDistributed_atLeastOneSectionFull() {
        let event = Event(name: "")

        for _ in 0 ..< Int.random(in: 1 ..< 100) {
            addOneHappening(at: TimeComponents(
                h: Int.random(in: 0 ..< 24),
                m: Int.random(in: 0 ..< 60),
                s: Int.random(in: 0 ..< 60)
            ), to: event)
        }

        let sut = ClockViewModel(event: event, size: Self.size, type: .day)

        XCTAssertGreaterThanOrEqual(sut.cells.filter { $0.length == 1.0 }.count, 1)
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
