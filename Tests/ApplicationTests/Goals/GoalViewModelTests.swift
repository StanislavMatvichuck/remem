//
//  GoalViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class GoalViewModelTests: XCTestCase {
    private var sut: GoalViewModel!

    override func setUp() {
        super.setUp()
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
        ))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Tests

    func test_init_requiresGoal() { XCTAssertNotNil(sut) }
    func test_readableDateCreated_localizedTextAndFormattedGoalDateCreated() {
        XCTAssertEqual(sut.readableDateCreated, "Goal created at 1 Jan 2001 at 00:00")

        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.adding(days: 1).date,
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
        ))

        XCTAssertEqual(sut.readableDateCreated, "Goal created at 2 Jan 2001 at 00:00")
    }

    func test_leftToAchieve_localizedTextAndGoalLeftToAchieve() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: GoalValue(amount: 3),
            event: event
        ))

        XCTAssertEqual(sut.readableLeftToAchieve, "2 left to achieve")
    }

    func test_progress_zero() { XCTAssertEqual(sut.progress, 0) }
    func test_progress_clampedToOne() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)

        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: GoalValue(amount: 3),
            event: event
        ))

        XCTAssertEqual(sut.progress, 1.0)
    }

    func test_isAchieved_false() { XCTAssertFalse(sut.isAchieved) }
    func test_readablePercent() { XCTAssertEqual(sut.readablePercent, "0%") }
    func test_readablePercent_33() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: GoalValue(amount: 3),
            event: event
        ))

        XCTAssertEqual(sut.readablePercent, "33%")
    }

    func test_readablePercent_133() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: GoalValue(amount: 3),
            event: event
        ))

        XCTAssertEqual(sut.readablePercent, "133%")
    }

    func test_readableValue_1() { XCTAssertEqual(sut.readableValue, "1") }
}
