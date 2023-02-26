//
//  DayChangeWatcherTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

@testable import Application
import XCTest

final class DayChangeWatcherDelegateSpy: DayChangeWatcherDelegate {
    var calledCount: Int = 0

    func handleDayChange() { calledCount += 1 }
}

final class DayChangeWatcherTests: XCTestCase {
    func test_init_isAnObject() {
        XCTAssertTrue(DayChangeWatcher() is AnyObject)
    }

    func test_canReceiveADelegate() {
        let sut = DayChangeWatcher()
        sut.delegate = DayChangeWatcherDelegateSpy()
    }

    func test_watch_severalTimes_doesNothing() {
        let sut = DayChangeWatcher()
        let delegate = DayChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch()
        sut.watch()
        sut.watch()

        XCTAssertEqual(delegate.calledCount, 0)
    }

    func test_watch_atDifferentDayIndexes_callsDelegate() {
        let sut = DayChangeWatcher()
        let delegate = DayChangeWatcherDelegateSpy()
        sut.delegate = delegate

        sut.watch(DayIndex.referenceValue.date)
        sut.watch(DayIndex.referenceValue.adding(days: 1).date)

        XCTAssertEqual(delegate.calledCount, 1)

        sut.watch(DayIndex.referenceValue.adding(days: 2).date)

        XCTAssertEqual(delegate.calledCount, 2)
    }
}
