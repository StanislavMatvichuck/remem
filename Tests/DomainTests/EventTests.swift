//
//  EventTests.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

@testable import Domain
import XCTest

final class EventTests: XCTestCase {
    var sut: Event!

    override func setUp() {
        sut = Event(name: "Event")
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initWithName_hasId() {
        XCTAssertEqual(sut.id.count, 36)
    }

    func test_initWithName_nameIsAssigned() {
        XCTAssertEqual(sut.name, "Event")
    }

    func test_initWithName_hasNoHappenings() {
        XCTAssertEqual(sut.happenings.count, 0)
    }

    func test_initWithName_isNotVisited() {
        XCTAssertNil(sut.dateVisited)
    }

    func test_initWithName_hasDateCreated() {
        XCTAssertNotNil(sut.dateCreated)
    }

    func test_initWithNameAndDate() {
        let dateCreated = Date(timeIntervalSinceReferenceDate: 0)
        let sut = Event(name: "Event", dateCreated: dateCreated)

        XCTAssertEqual(sut.name, "Event")
        XCTAssertEqual(sut.dateCreated, dateCreated)
    }

    func test_addHappening_addedOne() {
        sut.addHappening(date: Date.now)

        XCTAssertEqual(sut.happenings.count, 1)
    }

    func test_addHappening_addedTwo() {
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))

        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: secondHappeningDate)

        XCTAssertEqual(sut.happenings.count, 2)
    }

    func test_addHappening_happeningsAreSortedByDate() {
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))
        let thirdHappeningDate = Date.now.addingTimeInterval(TimeInterval(7.0))

        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: firstHappeningDate)

        XCTAssertEqual(sut.happenings[0], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[1], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[2], Happening(dateCreated: thirdHappeningDate))
    }

    func test_addHappening_manyHappenings_sortedByDate() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let firstHappeningDate = date.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = date.addingTimeInterval(TimeInterval(5.0))
        let thirdHappeningDate = date.addingTimeInterval(TimeInterval(7.0))

        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: secondHappeningDate)

        XCTAssertEqual(sut.happenings[0], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[1], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[2], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[3], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[4], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[5], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[6], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[7], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[8], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[9], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[10], Happening(dateCreated: thirdHappeningDate))
        XCTAssertEqual(sut.happenings[11], Happening(dateCreated: thirdHappeningDate))
        XCTAssertEqual(sut.happenings[12], Happening(dateCreated: thirdHappeningDate))
        XCTAssertEqual(sut.happenings[13], Happening(dateCreated: thirdHappeningDate))
        XCTAssertEqual(sut.happenings[14], Happening(dateCreated: thirdHappeningDate))

        XCTAssertTrue(sut.happenings[0].dateCreated < sut.happenings[14].dateCreated)
    }

    func test_addHappening_oneHappeningExists_addingHappeningLater_addsToEnd() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let dateLater = date.addingTimeInterval(60 * 60 * 24 + 15)

        sut.addHappening(date: date)
        sut.addHappening(date: dateLater)

        XCTAssertTrue(sut.happenings[0].dateCreated < sut.happenings[1].dateCreated)
    }

    func test_visit_hasDateVisited() {
        XCTAssertNil(sut.dateVisited)
        sut.visit()
        XCTAssertNotNil(sut.dateVisited)
    }

    func test_goalAmountAtDate_returns0() {
        XCTAssertEqual(sut.weeklyGoalAmount(at: Date.distantPast), 0)
        XCTAssertEqual(sut.weeklyGoalAmount(at: Date.distantFuture), 0)
    }

    func test_setGoal() {
        let eventDateCreated = Date(timeIntervalSinceReferenceDate: 0)
        sut = Event(name: "Event", dateCreated: eventDateCreated)

        sut.setWeeklyGoal(amount: 1, for: eventDateCreated)

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 1)
    }

    func test_setGoal_inSameWeek_updatesExistingGoal() {
        let eventDateCreated = Date(timeIntervalSinceReferenceDate: 0)
        sut = Event(name: "Event", dateCreated: eventDateCreated)

        sut.setWeeklyGoal(amount: 1, for: eventDateCreated)
        sut.setWeeklyGoal(amount: 2, for: eventDateCreated.addingTimeInterval(60))

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 2)
    }

    func test_setGoal_nextWeek_previousGoalPreserved() {
        let eventDateCreated = Date(timeIntervalSinceReferenceDate: 0)
        let nextWeekDate = eventDateCreated.addingTimeInterval(60 * 60 * 24 * 7)
        sut = Event(name: "Event", dateCreated: eventDateCreated)

        sut.setWeeklyGoal(amount: 1, for: eventDateCreated)
        sut.setWeeklyGoal(amount: 2, for: nextWeekDate)
        sut.setWeeklyGoal(amount: 3, for: nextWeekDate)

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 1)
        XCTAssertEqual(sut.weeklyGoalAmount(at: nextWeekDate), 3)
    }

    func test_setGoal_threeGoalsExist_secondOneCanBeUpdatedWithoutChangesInFirstAndThird() {
        let eventDateCreated = Date(timeIntervalSinceReferenceDate: 0)
        let nextWeekDate = eventDateCreated.addingTimeInterval(60 * 60 * 24 * 7)
        let thirdWeekDate = nextWeekDate.addingTimeInterval(60 * 60 * 24 * 7)
        sut = Event(name: "Event", dateCreated: eventDateCreated)

        sut.setWeeklyGoal(amount: 1, for: eventDateCreated)
        sut.setWeeklyGoal(amount: 2, for: nextWeekDate)
        sut.setWeeklyGoal(amount: 3, for: thirdWeekDate)

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 1)
        XCTAssertEqual(sut.weeklyGoalAmount(at: nextWeekDate), 2)
        XCTAssertEqual(sut.weeklyGoalAmount(at: thirdWeekDate), 3)

        sut.setWeeklyGoal(amount: 0, for: nextWeekDate)

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 1)
        XCTAssertEqual(sut.weeklyGoalAmount(at: nextWeekDate), 0)
        XCTAssertEqual(sut.weeklyGoalAmount(at: thirdWeekDate), 3)
    }

    func test_setGoal_goalTransfersToNextWeek() {
        let eventDateCreated = Date(timeIntervalSinceReferenceDate: 0)
        let nextWeekDate = eventDateCreated.addingTimeInterval(60 * 60 * 24 * 7)
        sut = Event(name: "Event", dateCreated: eventDateCreated)
        sut.setWeeklyGoal(amount: 1, for: eventDateCreated)

        XCTAssertEqual(sut.weeklyGoalAmount(at: eventDateCreated), 1)
        XCTAssertEqual(sut.weeklyGoalAmount(at: nextWeekDate), 1)
    }
}
