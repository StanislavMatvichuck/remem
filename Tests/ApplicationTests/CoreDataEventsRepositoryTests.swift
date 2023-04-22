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
        let mapper = EventEntityMapper()

        sut = CoreDataEventsRepository(container: container, mapper: mapper)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_save_increasesCount() {
        XCTAssertEqual(sut.get().count, 0)

        sut.save(Event(name: ""))

        XCTAssertEqual(sut.get().count, 1)
    }

    func test_save_eventWithHappening() {
        let savedEvent = Event(name: "")

        savedEvent.addHappening(date: DayIndex.referenceValue.date)

        sut.save(savedEvent)

        let acquiredEvent = sut.event(byId: savedEvent.id)

        XCTAssertEqual(acquiredEvent.happenings.count, 1)
    }

    func test_save_eventWith_N_Happenings() {
        let savedEvent = Event(name: "")

        for i in 0 ..< 10 {
            savedEvent.addHappening(date: DayIndex.referenceValue.date.addingTimeInterval(-1 * Double(i) * 5.0))
        }

        sut.save(savedEvent)

        let acquiredEvent = sut.event(byId: savedEvent.id)

        XCTAssertEqual(acquiredEvent.happenings.count, 10)
    }

    func test_save_renamedEvent() {
        let newEvent = givenSavedDefaultEvent()

        newEvent.name = "Updated name"

        sut.save(newEvent)

        let acquiredEvent = sut.event(byId: newEvent.id)

        XCTAssertEqual(acquiredEvent.name, newEvent.name)
    }

    func test_save_allPossibleModifications() throws {
        let newEvent = givenSavedDefaultEvent()

        // renaming
        newEvent.name = "UpdatedName"
        sut.save(newEvent)
        // adding happenings
        for i in 0 ... 10 { newEvent.addHappening(date: Date.now.addingTimeInterval(-1 * Double(i) * 5.0)) }
        sut.save(newEvent)
        // removing happening
        if let removedHappening = newEvent.happenings.first {
            try newEvent.remove(happening: removedHappening)
        }

        sut.save(newEvent)
        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_delete_decreasesCount() {
        let event = givenSavedDefaultEvent()

        sut.delete(event)

        XCTAssertEqual(sut.get().count, 0)
    }

    private func givenSavedDefaultEvent() -> Event {
        let newEvent = Event(name: "Event")
        sut.save(newEvent)
        return newEvent
    }
}

private extension CoreDataEventsRepository {
    func event(byId: String) -> Event {
        let all = get()

        guard let index = all.firstIndex(where: { $0.id == byId })
        else { fatalError("unable to find event by id \(byId)") }

        return all[index]
    }
}
