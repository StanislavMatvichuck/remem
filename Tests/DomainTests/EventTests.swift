//
//  EventTests.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

@testable import Domain
import XCTest

class EventTests: XCTestCase {
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

    func test_initWithName_hasNoGoals() {
        for date in Date.now.dayByDayWeekForward {
            XCTAssertNil(sut.goal(at: date))
        }
    }

    func testInit_dateCreatedIsStartOfDay() {
        let todayComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .now)
        let components = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sut.dateCreated)

        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)

        XCTAssertEqual(components.day, todayComponents.day)
        XCTAssertEqual(components.month, todayComponents.month)
        XCTAssertEqual(components.year, todayComponents.year)
    }

    func test_addHappening_addedOne() throws {
        let happeningDate = Date.now

        sut.addHappening(date: happeningDate)

        XCTAssertEqual(sut.happenings.count, 1)
    }

    func test_addHappening_addedTwo() throws {
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))

        sut.addHappening(date: firstHappeningDate)
        sut.addHappening(date: secondHappeningDate)

        XCTAssertEqual(sut.happenings.count, 2)
    }

    func test_addHappening_sorted() throws {
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

    func test_visit() {
        sut.visit()
        XCTAssertNotNil(sut.dateVisited)
    }
}

// MARK: - Private
extension EventTests {
    var cal: Calendar { Calendar.current }
}
