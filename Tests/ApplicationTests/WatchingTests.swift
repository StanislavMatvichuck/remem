//
//  DayChangeWatcherTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

@testable import Application
import XCTest

final class ChangeWatcherDelegateSpy: Updating {
    var calledCount: Int = 0

    func update() { calledCount += 1 }
}

final class DayChangeWatcherTests: XCTestCase {
    func test_init_isAnObject() {
        XCTAssertTrue(DayWatcher() is AnyObject)
    }

    func test_canReceiveADelegate() {
        let sut = DayWatcher()
        sut.delegate = ChangeWatcherDelegateSpy()
    }

    func test_watch_severalTimes_doesNothing() {
        let sut = DayWatcher()
        let delegate = ChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(.now)
        sut.watch(.now)
        sut.watch(.now)

        XCTAssertEqual(delegate.calledCount, 0)
    }

    func test_watch_atDifferentDays_callsDelegate() {
        let sut = DayWatcher()
        let day = DayIndex.referenceValue
        let delegate = ChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(day.date)
        sut.watch(day.adding(days: 1).date)

        XCTAssertEqual(delegate.calledCount, 1)

        sut.watch(day.adding(days: 2).date)

        XCTAssertEqual(delegate.calledCount, 2)
    }
}

final class MinuteChangeWatcherTests: XCTestCase {
    func test_init_isAnObject() {
        XCTAssertTrue(MinuteWatcher() is AnyObject)
    }

    func test_canReceiveADelegate() {
        let sut = MinuteWatcher()
        sut.delegate = ChangeWatcherDelegateSpy()
    }

    func test_watch_severalTimes_doesNothing() {
        let sut = DayWatcher()
        let delegate = ChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(.now)
        sut.watch(.now)
        sut.watch(.now)

        XCTAssertEqual(delegate.calledCount, 0)
    }

    func test_watch_atDifferentDays_callsDelegate() {
        let sut = MinuteWatcher()
        let day = DayIndex.referenceValue
        let delegate = ChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(day.date)
        sut.watch(day.adding(days: 1).date)

        XCTAssertEqual(delegate.calledCount, 1)

        sut.watch(day.adding(days: 2).date)

        XCTAssertEqual(delegate.calledCount, 2)
    }

    func test_watch_atDifferentMinutes_callsDelegate() {
        let sut = MinuteWatcher()
        let day = DayIndex.referenceValue
        let delegate = ChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(day.date)
        sut.watch(day.date.addingTimeInterval(60.0))

        XCTAssertEqual(delegate.calledCount, 1)

        sut.watch(day.date.addingTimeInterval(2 * 60.0))

        XCTAssertEqual(delegate.calledCount, 2)
    }
}
