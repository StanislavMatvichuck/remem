//
//  CoreDataEventsRepositoryTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

@testable import Remem
import XCTest

class CoreDataEventsRepositoryTests: XCTestCase {
    private var sut: CoreDataEventsRepository!

    override func setUp() {
        super.setUp()

        let container = CoreDataStack.createContainer(inMemory: true)
        let mapper = EventEntityMapper()

        sut = CoreDataEventsRepository(container: container, mapper: mapper)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertEqual(sut.all().count, 0)
    }

    func test_save_newEvent() {
        let newEvent = givenSavedDefaultEvent()

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
        XCTAssertEqual(sut.all().count, 1)
    }

    func test_save_eventWithNewHappening() {
        var newEvent = givenSavedDefaultEvent()

        do {
            try newEvent.addHappening(date: .now)
        } catch {}

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_renamedEvent() {
        var newEvent = givenSavedDefaultEvent()

        newEvent.name = "Updated name"

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_delete_success() {
        let event = givenSavedDefaultEvent()

        sut.delete(event)

        XCTAssertEqual(sut.all().count, 0)
    }
}

// MARK: - Private
extension CoreDataEventsRepositoryTests {
    private func givenSavedDefaultEvent() -> Event {
        let newEvent = Event.make(name: "Event")

        sut.save(newEvent)

        return newEvent
    }
}
