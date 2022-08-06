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
        let id = UUID().uuidString
        let name = "EventName"
        let happenings = [Happening]()
        let dateCreated = Date.now
        let sut = Event(id: id,
                        name: name,
                        happenings: happenings,
                        dateCreated: dateCreated)

        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.name, name)
        XCTAssertEqual(sut.happenings, happenings)
        XCTAssertEqual(sut.happenings.count, 0)
        XCTAssertEqual(sut.dateCreated, dateCreated)
        XCTAssertNil(sut.dateVisited)
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
        let id = UUID().uuidString
        let name = "EventName"
        let happenings = [Happening]()
        let dateCreated = Date.now
        return Event(id: id,
                     name: name,
                     happenings: happenings,
                     dateCreated: dateCreated)
    }
}
