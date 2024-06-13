//
//  CoreDataEventsRepositoryTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

@testable import Application
import DataLayer
import Domain
import XCTest

final class CoreDataEventsRepositoryTests: XCTestCase {
    private var sut: CoreDataEventsRepository!

    override func setUp() {
        super.setUp()

        let container = CoreDataStack.createContainer(inMemory: true)

        sut = CoreDataEventsRepository(container: container)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_save_increasesCount() {
        XCTAssertEqual(sut.identifiers(using: .name).count, 0)

        sut.create(event: Event(name: ""))

        XCTAssertEqual(sut.identifiers(using: .name).count, 1)
    }

    func test_save_eventWithHappening() {
        var savedEvent = Event(name: "")

        savedEvent.addHappening(date: DayIndex.referenceValue.date)

        sut.create(event: savedEvent)

        let acquiredEvent = sut.read(byId: savedEvent.id)
        XCTAssertEqual(acquiredEvent, savedEvent)
    }

    func test_save_eventWith_N_Happenings() {
        var savedEvent = Event(name: "")

        for i in 0 ..< 10 {
            savedEvent.addHappening(date: DayIndex.referenceValue.date.addingTimeInterval(-1 * Double(i) * 5.0))
        }

        sut.create(event: savedEvent)

        let acquiredEvent = sut.read(byId: savedEvent.id)
        XCTAssertEqual(acquiredEvent, savedEvent)
    }

    func test_save_renamedEvent() {
        var newEvent = givenSavedDefaultEvent()

        newEvent.name = "Updated name"

        sut.update(id: newEvent.id, event: newEvent)

        let acquiredEvent = sut.read(byId: newEvent.id)
        XCTAssertEqual(acquiredEvent, newEvent)
    }

    func test_save_allPossibleModifications() throws {
        var newEvent = givenSavedDefaultEvent()

        // renaming
        newEvent.name = "UpdatedName"
        sut.update(id: newEvent.id, event: newEvent)
        // adding happenings
        for i in 0 ... 10 { newEvent.addHappening(date: Date.now.addingTimeInterval(-1 * Double(i) * 5.0)) }
        sut.update(id: newEvent.id, event: newEvent)
        // removing happening
        if let removedHappening = newEvent.happenings.first {
            try newEvent.remove(happening: removedHappening)
        }

        sut.update(id: newEvent.id, event: newEvent)
        XCTAssertEqual(sut.read(byId: newEvent.id), newEvent)
    }

    func test_delete_decreasesCount() {
        let event = givenSavedDefaultEvent()

        sut.delete(id: event.id)

        XCTAssertEqual(sut.identifiers(using: .name).count, 0)
    }

    private func givenSavedDefaultEvent() -> Event {
        let newEvent = Event(name: "Event")
        sut.create(event: newEvent)
        return newEvent
    }
}
