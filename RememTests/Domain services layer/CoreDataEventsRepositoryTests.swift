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

    func test_save_eventWithHappening() {
        let newEvent = givenSavedDefaultEvent()

        do {
            try newEvent.addHappening(date: .now)
        } catch {}

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_eventWith_N_Happenings() {
        let newEvent = givenSavedDefaultEvent()

        do {
            for i in 0 ... 10 {
                try newEvent.addHappening(date: Date.now.addingTimeInterval(-1 * Double(i) * 5.0))
            }
        } catch {}

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_renamedEvent() {
        let newEvent = givenSavedDefaultEvent()

        newEvent.name = "Updated name"

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_allPossibleModifications() {
        let newEvent = givenSavedDefaultEvent()

        // renaming
        newEvent.name = "UpdatedName"

        sut.save(newEvent)

        // adding happenings
        do {
            for i in 0 ... 10 {
                try newEvent.addHappening(date: Date.now.addingTimeInterval(-1 * Double(i) * 5.0))
            }
        } catch {}

        sut.save(newEvent)

        // removing happening
        do {
            try newEvent.remove(happening: Happening(dateCreated: Date.now))
        } catch {}

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
        let newEvent = Event(name: "Event")
        sut.save(newEvent)
        return newEvent
    }
}
