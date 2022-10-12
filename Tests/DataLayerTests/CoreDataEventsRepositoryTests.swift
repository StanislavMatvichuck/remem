//
//  CoreDataEventsRepositoryTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

@testable import DataLayer
import Domain
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
        XCTAssertEqual(sut.makeAllEvents().count, 0)
    }

    func test_save_newEvent() {
        let newEvent = givenSavedDefaultEvent()

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
        XCTAssertEqual(sut.makeAllEvents().count, 1)
    }

    func test_save_eventWithHappening() {
        let newEvent = givenSavedDefaultEvent()

        newEvent.addHappening(date: Date.now)

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_eventWith_N_Happenings() {
        let newEvent = givenSavedDefaultEvent()
        for i in 0 ... 10 {
            newEvent.addHappening(date: Date.now.addingTimeInterval(-1 * Double(i) * 5.0))
        }

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_renamedEvent() {
        let newEvent = givenSavedDefaultEvent()
        newEvent.name = "Updated name"

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_save_eventWithGoal() {
        let newEvent = givenSavedDefaultEvent()
        let goal = newEvent.addGoal(at: .now, amount: 1)

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id)?.goal(at: .now), goal)
    }

    func test_save_eventWithGoals() {
        let newEvent = givenSavedDefaultEvent()
        _ = newEvent.addGoal(at: .now, amount: 1)
        let goal2 = newEvent.addGoal(at: .now.addingTimeInterval(5.0), amount: 2)
        let goal3 = newEvent.addGoal(at: .now.addingTimeInterval(60 * 60 * 24), amount: 3)

        sut.save(newEvent)

        XCTAssertEqual(sut.event(byId: newEvent.id)?.goal(at: .now.addingTimeInterval(5.0)), goal2)
        XCTAssertEqual(sut.event(byId: newEvent.id)?.goal(at: .now.addingTimeInterval(60 * 60 * 24)), goal3)
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
        // adding goal
        newEvent.addGoal(at: .now, amount: 1)
        sut.save(newEvent)
        // updating goal
        newEvent.addGoal(at: .now.addingTimeInterval(5.0), amount: 2)
        sut.save(newEvent)
        XCTAssertEqual(sut.event(byId: newEvent.id), newEvent)
    }

    func test_delete_success() {
        let event = givenSavedDefaultEvent()
        sut.delete(event)
        XCTAssertEqual(sut.makeAllEvents().count, 0)
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
