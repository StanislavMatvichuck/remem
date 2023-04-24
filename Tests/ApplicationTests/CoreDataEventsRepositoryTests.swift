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

    func test_getUsingSorter_sortedAlphabetically() {
        let event01 = Event(name: "a")
        let event02 = Event(name: "b")
        let event03 = Event(name: "c")

        sut.save(event01)
        sut.save(event03)
        sut.save(event02)

        XCTAssertEqual(event01.name, sut.get(using: .alphabetical)[0].name)
        XCTAssertEqual(event02.name, sut.get(using: .alphabetical)[1].name)
        XCTAssertEqual(event03.name, sut.get(using: .alphabetical)[2].name)
    }

    func test_getUsingSorter_byHappeningsAmount() {
        let date = DayIndex.referenceValue.date
        let event01 = Event(name: "c", dateCreated: date)
        event01.addHappening(date: date)
        event01.addHappening(date: date)
        let event02 = Event(name: "b", dateCreated: date)
        event02.addHappening(date: date)
        let event03 = Event(name: "a", dateCreated: date)

        sut.save(event01)
        sut.save(event03)
        sut.save(event02)

        XCTAssertEqual(event01.name, sut.get(using: .happeningsCountTotal)[0].name)
        XCTAssertEqual(event02.name, sut.get(using: .happeningsCountTotal)[1].name)
        XCTAssertEqual(event03.name, sut.get(using: .happeningsCountTotal)[2].name)
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
