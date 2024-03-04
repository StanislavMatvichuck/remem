//
//  GoalIncrementCommandTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 04.03.2024.
//

import Foundation

@testable import Application
import Domain
import Foundation
import XCTest

final class GoalCommandsTests: XCTestCase {
//    override func setUp() {
//        super.setUp()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//    }

    // MARK: - Tests
    func test_incrementsGoalValueByOne() {
        let goal = Goal(dateCreated: DayIndex.referenceValue.date, event: Event(name: ""))

        let sut = GoalIncrementCommand(goal: goal, repository: RepositoryFake(), updater: UpdaterFake())

        sut.execute()

        XCTAssertEqual(goal.value.amount, 2)
    }

    func test_decrementsGoalValueByOne() {
        let goal = Goal(dateCreated: DayIndex.referenceValue.date, value: GoalValue(amount: 2), event: Event(name: ""))

        let sut = GoalDecrementCommand(goal: goal, repository: RepositoryFake(), updater: UpdaterFake())

        sut.execute()

        XCTAssertEqual(goal.value.amount, 1)
    }

    func test_createGoal() {
        let repository = RepositoryFake()

        XCTAssertEqual(repository.get(for: Event(name: "")).count, 0)

        let sut = GoalCreateCommand(repository: repository, updater: UpdaterFake(), date: DayIndex.referenceValue.date, count: 1, event: Event(name: ""))

        sut.execute()

        XCTAssertEqual(repository.get(for: Event(name: "")).count, 1)
    }

    // TODO: add tests for saving and updating?
}

private final class RepositoryFake: GoalsCommanding, GoalsQuerying {
    private var goals: [Goal] = []
    func save(_ goal: Goal) { goals.append(goal) }
    func remove(_ goal: Goal) {}
    func get(for: Event) -> [Goal] {
        goals
    }
}

private struct UpdaterFake: Updating {
    func update() {}
}
