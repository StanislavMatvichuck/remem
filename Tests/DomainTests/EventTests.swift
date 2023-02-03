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
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))
        let thirdHappeningDate = Date.now.addingTimeInterval(TimeInterval(7.0))

        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: secondHappeningDate)
        sut.addHappening(date: thirdHappeningDate)
        sut.addHappening(date: firstHappeningDate)
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

    func test_visit_hasDateVisited() {
        XCTAssertNil(sut.dateVisited)
        sut.visit()
        XCTAssertNotNil(sut.dateVisited)
    }

    // MOVE THESE TESTS TO APPLICATION LAYER
//    func test_hasHappeningAtDayOfCreation_getHappeningsForDay_returnsOne() {
//        let (sut, dayOfCreation) = arrangeWithOneHappeningOneHourAfterCreation()
//
//        let happeningsForFirstDay = sut.happenings(forDayIndex: dayOfCreation)
//
//        XCTAssertEqual(happeningsForFirstDay.count, 1)
//    }
//
//    func test_hasHappeningAtDayOfCreation_getHappeningsForNextDay_returnsNone() {
//        let (sut, dayOfCreation) = arrangeWithOneHappeningOneHourAfterCreation()
//
//        let nextDay = dayOfCreation.adding(components: DateComponents(day: 1))
//        let happeningsForFirstDay = sut.happenings(forDayIndex: nextDay)
//
//        XCTAssertEqual(happeningsForFirstDay.count, 0)
//    }

//    private func arrangeWithOneHappeningOneHourAfterCreation() -> (Event, DayIndex) {
//        let day = DayIndex.referenceValue
//        let date = day.date
//        let sut = Event(name: "Event", dateCreated: date)
//        sut.addHappening(date: date.addingTimeInterval(60 * 60))
//        return (sut, day)
//    }
}
