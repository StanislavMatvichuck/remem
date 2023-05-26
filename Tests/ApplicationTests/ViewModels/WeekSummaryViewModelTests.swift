//
//  NewEventWeeklyGoalViewModelTests.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.05.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekSummaryViewModelTests: XCTestCase {
    private var sut: WeekSummaryViewModel!

    override func setUp() {
        super.setUp()
        sut = makeForOneWeek()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_pastWeek_title() {
        sut = makeForTwoWeeks()
        XCTAssertEqual(String(localizationId: "weeklyGoal.week") + " 1", sut.title)
    }

    func test_currentWeek_title() {
        XCTAssertEqual(String(localizationId: "weeklyGoal.week") + " 1", sut.title)
    }

    func test_pastWeek_noGoal() {
        event.addHappening(date: dayCreated.date)
        sut = makeForTwoWeeks()

        XCTAssertFalse(sut.goalTappable)
        XCTAssertTrue(sut.goalHidden)
        XCTAssertTrue(sut.progressHidden)
    }

    func test_pastWeek_goalSet_amountIsZero() {
        event.setWeeklyGoal(amount: 1, for: dayCreated.date)
        sut = makeForTwoWeeks()

        XCTAssertTrue(sut.progressHidden)
        XCTAssertFalse(sut.goalTappable)
        XCTAssertFalse(sut.goalHidden)
        XCTAssertEqual("1", sut.goal)
        XCTAssertEqual("0", sut.amount)
    }

    func test_pastWeek_goalSet_amountIsNotZero() {
        event.addHappening(date: dayCreated.date)
        event.setWeeklyGoal(amount: 1, for: dayCreated.date)
        sut = makeForTwoWeeks()

        XCTAssertFalse(sut.goalTappable)
        XCTAssertFalse(sut.progressHidden)
    }

    func test_currentWeek_withoutGoal() {
        XCTAssertTrue(sut.goalTappable)
        XCTAssertTrue(sut.progressHidden)
        XCTAssertFalse(sut.goalHidden)
    }

    func test_currentWeek_goalSet_amountIsZero() {
        event.setWeeklyGoal(amount: 1, for: dayCreated.date)
        sut = makeForOneWeek()

        XCTAssertTrue(sut.goalTappable)
        XCTAssertTrue(sut.progressHidden)
        XCTAssertEqual("0", sut.amount)
        XCTAssertEqual("1", sut.goal)
    }

    func test_currentWeek_goalSet_amountIsNotZero_goalNotAchieved() {
        event.addHappening(date: dayCreated.date)
        event.addHappening(date: dayCreated.date)
        event.addHappening(date: dayCreated.date)
        event.setWeeklyGoal(amount: 12, for: dayCreated.date)
        sut = makeForOneWeek()

        XCTAssertTrue(sut.goalTappable)
        XCTAssertFalse(sut.goalAchieved)
        XCTAssertFalse(sut.goalHidden)
        XCTAssertEqual("12", sut.goal)
        
        XCTAssertFalse(sut.progressHidden)
        XCTAssertEqual("25", sut.progress)
    }

    func test_currentWeek_goalSet_goalAchieved() {
        event.addHappening(date: dayCreated.date)
        event.setWeeklyGoal(amount: 1, for: dayCreated.date)
        sut = makeForOneWeek()

        XCTAssertTrue(sut.goalTappable)
        XCTAssertTrue(sut.goalAchieved)
        XCTAssertFalse(sut.goalHidden)

        XCTAssertFalse(sut.progressHidden)
        XCTAssertEqual("100", sut.progress)

        XCTAssertEqual("1", sut.amount)
        XCTAssertEqual("1", sut.goal)
    }

    // MARK: - Private
    var dayCreated = DayIndex.referenceValue
    lazy var event = Event(name: "Event", dateCreated: dayCreated.date)
    lazy var today = dayCreated.adding(days: 8)

    private func makeForOneWeek() -> WeekSummaryViewModel {
        makeForEventAnd(today: dayCreated)
    }

    private func makeForTwoWeeks() -> WeekSummaryViewModel {
        makeForEventAnd(today: today)
    }

    private func makeForEventAnd(today: DayIndex) -> WeekSummaryViewModel {
        let container = ApplicationContainer(testingInMemoryMode: true)
        let details = container.makeContainer().makeContainer(event: event, today: today)
        return details.makeWeekViewController().viewModel.pages.first!!
    }
}
