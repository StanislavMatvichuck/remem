//
//  ClockStrategyTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 01.12.2022.
//

@testable import Application
import Domain
import XCTest

class DefaultClockStrategyTests: XCTestCase {
    func test_returnsSizeSections() {
        let size = 144
        let sut = DefaultClockSorter(size: size)
        let sections = sut.sort(orderedByDateHappenings: [])

        XCTAssertEqual(sections.count, size)
    }

    func test_secondsInSection_dependsOnSize() {
        var size = 86400
        var sut = DefaultClockSorter(size: size)
        XCTAssertEqual(sut.secondsInSection, 1)

        size = 144
        sut = DefaultClockSorter(size: size)
        XCTAssertEqual(sut.secondsInSection, 600)
    }

    func test_secondsForFirstSection_equalToSecondsInSection() {
        let sut = DefaultClockSorter(size: 144)
        let seconds = sut.seconds(forSection: 0)

        XCTAssertEqual(seconds, sut.secondsInSection)
    }

    func test_secondsForLastSection_equalToSizeInSeconds() {
        let size = 144
        let sut = DefaultClockSorter(size: size)
        let seconds = sut.seconds(forSection: size - 1)

        XCTAssertEqual(seconds, sut.secondsInDay)
    }

    func test_secondsForHappeningWithMaximumTime_lessThanSecondsInDay() {
        let sut = DefaultClockSorter(size: 144)

        let happening = Happening(dateCreated: Calendar.current.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: Date.now
        )!)

        let seconds = sut.seconds(for: happening)

        XCTAssertLessThan(seconds, sut.secondsInDay)
    }

    func test_happeningWithMaximumTime_goesToLastSection() {
        let sut = DefaultClockSorter(size: 144)
        let happening = Happening(dateCreated: Calendar.current.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: Date.now
        )!)
        let lastSection = sut.sort(orderedByDateHappenings: [happening]).last

        XCTAssertEqual(lastSection?.length, 1)
    }

    func test_happeningWithMinimumTime_goesToFirstSection() {
        let sut = DefaultClockSorter(size: 144)
        let happening = Happening(dateCreated: Calendar.current.date(
            bySettingHour: 0,
            minute: 0,
            second: 0,
            of: Date.now
        )!)
        let firstSection = sut.sort(orderedByDateHappenings: [happening]).first

        XCTAssertEqual(firstSection?.length, 1)
    }

    func test_oneHappening_takesOneSection() {
        let sut = DefaultClockSorter(size: 144)
        let happening = Happening(dateCreated: Calendar.current.date(
            bySettingHour: Int.random(in: 0 ..< 24),
            minute: Int.random(in: 0 ..< 60),
            second: Int.random(in: 0 ..< 60),
            of: Date.now
        )!)
        let notEmptySections = sut.sort(orderedByDateHappenings: [happening]).filter { !$0.isEmpty }

        XCTAssertEqual(notEmptySections.count, 1)
    }
}
