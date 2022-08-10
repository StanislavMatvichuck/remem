//
//  EventTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

@testable import Remem
import XCTest

class EventTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let name = "EventName"
        let sut = Event.make(name: name)

        XCTAssertEqual(sut.id.count, 36)
        XCTAssertEqual(sut.name, name)
        XCTAssertEqual(sut.happenings.count, 0)
        XCTAssertNil(sut.dateVisited)
    }

    func testInit_dateCreatedIsStartOfDay() {
        let sut = makeDefaultEvent()

        let todayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .now)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sut.dateCreated)

        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)

        XCTAssertEqual(components.day, todayComponents.day)
        XCTAssertEqual(components.month, todayComponents.month)
        XCTAssertEqual(components.year, todayComponents.year)
    }

    func test_addHappening_addedOne() {
        var sut = makeDefaultEvent()
        let happeningDate = Date.now

        do {
            try sut.addHappening(date: happeningDate)
        } catch {}

        XCTAssertEqual(sut.happenings.count, 1)
    }

    func test_addHappening_addedTwo() {
        var sut = makeDefaultEvent()
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))

        do {
            try sut.addHappening(date: firstHappeningDate)
            try sut.addHappening(date: secondHappeningDate)
        } catch {}

        XCTAssertEqual(sut.happenings.count, 2)
    }

    func test_addHappening_incorrectDate() {
        var sut = makeDefaultEvent()
        let date = Date.distantPast

        do {
            try sut.addHappening(date: date)
        } catch {
            XCTAssertEqual(error as! EventManipulationError, EventManipulationError.incorrectHappeningDate)
        }

        XCTAssertEqual(sut.happenings.count, 0)
    }

    func test_addHappening_sorted() {
        var sut = makeDefaultEvent()
        let firstHappeningDate = Date.now.addingTimeInterval(TimeInterval(3.0))
        let secondHappeningDate = Date.now.addingTimeInterval(TimeInterval(5.0))
        let thirdHappeningDate = Date.now.addingTimeInterval(TimeInterval(7.0))

        do {
            try sut.addHappening(date: thirdHappeningDate)
            try sut.addHappening(date: secondHappeningDate)
            try sut.addHappening(date: firstHappeningDate)
        } catch {}

        XCTAssertEqual(sut.happenings.count, 3)
        XCTAssertEqual(sut.happenings[0], Happening(dateCreated: firstHappeningDate))
        XCTAssertEqual(sut.happenings[1], Happening(dateCreated: secondHappeningDate))
        XCTAssertEqual(sut.happenings[2], Happening(dateCreated: thirdHappeningDate))
    }

    func test_visit() {
        var sut = makeDefaultEvent()

        sut.visit()

        XCTAssertNotNil(sut.dateVisited)
    }
}

// MARK: - Private
extension EventTests {
    private func makeDefaultEvent() -> Event {
        return Event.make(name: "EventName")
    }
}
