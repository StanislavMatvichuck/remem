//
//  GoalTests.swift
//  RememDomainTests
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

@testable import RememDomain
import XCTest

class GoalTests: XCTestCase {
    var sut: Event!

    override func setUp() {
        sut = makeEventWithGoal()
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_addGoal_eachDay() {
        for date in Date.now.dayByDayWeekForward {
            let sut = Event(name: "EventName")

            let goal = sut.addGoal(at: date, amount: 1)

            XCTAssertEqual(sut.goal(at: date), goal)
        }
    }

    func test_addGoal_addedOverExistingGoal() {
        let secondGoal = sut.addGoal(at: .now, amount: 2)

        XCTAssertEqual(sut.goal(at: .now.addingTimeInterval(1.0)), secondGoal)
    }

    func test_addGoal_affectsNextWeek() {
        sut.addGoal(at: .now, amount: 2)

        XCTAssertEqual(sut.goal(at: Date.now.days(ago: -7))?.amount, 2)
    }

    func test_addGoal_pastWeekPreserved() {
        sut.addGoal(at: Date.now.days(ago: -7), amount: 2)

        XCTAssertEqual(sut.goal(at: .now)?.amount, 1)
    }

    func test_addGoal_canBeReached() {
        for goalReached in [true, false] {
            let sut = makeEventWithGoal()
            sut.addHappening(date: .now)
            _ = goalReached ? sut.addHappening(date: .now) : nil

            sut.addGoal(at: .now, amount: 2)

            XCTAssertEqual(sut.goal(at: .now)?.isReached(at: .now), goalReached)
        }
    }

    func test_addHappening_goalCanBeReached() throws {
        for goalReached in [true, false] {
            let sut = makeEventWithGoal(amount: goalReached ? 1 : 2)

            sut.addHappening(date: .now)

            XCTAssertEqual(sut.goal(at: .now)?.isReached(at: .now), goalReached)
        }
    }

    func test_removeHappening_goalCanBeReached() throws {
        for goalReached in [true, false] {
            let sut = makeEventWithGoal()
            let happening = sut.addHappening(date: .now)
            _ = goalReached ? sut.addHappening(date: .now.addingTimeInterval(0.5)) : nil

            try sut.remove(happening: happening)

            XCTAssertEqual(sut.goal(at: .now)?.isReached(at: .now), goalReached)
        }
    }
}

// MARK: - Private
extension GoalTests {
    private func makeEventWithGoal(date: Date = .now, amount: Int = 1) -> Event {
        let sut = Event(name: "EventName")
        sut.addGoal(at: date, amount: amount)
        return sut
    }
}
