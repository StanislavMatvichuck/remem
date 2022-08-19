//
//  EventTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

@testable import Remem
import XCTest

class EventTests: XCTestCase {
    var sut: Event!

    override func setUp() {
        super.setUp()
        sut = Event(name: "Event")
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertEqual(sut.id.count, 36)
        XCTAssertEqual(sut.name, "Event")
        XCTAssertEqual(sut.happenings.count, 0)
        XCTAssertNil(sut.dateVisited)

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

        try sut.addHappening(date: happeningDate)

        XCTAssertEqual(sut.happenings.count, 1)
    }

    func test_addHappening_addedTwo() throws {
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))

        try sut.addHappening(date: firstHappeningDate)
        try sut.addHappening(date: secondHappeningDate)
        XCTAssertEqual(sut.happenings.count, 2)
    }

    func test_addHappening_sorted() throws {
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))
        let thirdHappeningDate = Date.now.addingTimeInterval(TimeInterval(7.0))

        try sut.addHappening(date: thirdHappeningDate)
        try sut.addHappening(date: secondHappeningDate)
        try sut.addHappening(date: firstHappeningDate)

        XCTAssertEqual(sut.happenings.count, 3)
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
