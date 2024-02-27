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
            value: 1,
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
        XCTAssertEqual(sut.readableDateCreated, "Goal created at 1 Jan 2001")

        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.adding(days: 1).date,
            value: 0,
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
        ))

        XCTAssertEqual(sut.readableDateCreated, "Goal created at 2 Jan 2001")
    }

    func test_leftToAchieve_localizedTextAndGoalLeftToAchieve() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: 3,
            event: event
        ))

        XCTAssertEqual(sut.readableLeftToAchieve, "2 left to achieve")
    }

    func test_progress_zero() { XCTAssertEqual(sut.progress, 0) }
    func test_isAchieved_false() { XCTAssertFalse(sut.isAchieved) }
}
