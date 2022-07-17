//
//  RememTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 15.04.2022.
//

@testable import Remem

import CoreData
import XCTest

class EventsListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var service: EventsListService!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        service = EventsListService(moc: container.viewContext, stack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        service = nil
    }

    func testSetUp() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(service)
    }

    func testCreatedStoreIsEmpty() {
        let count = try? service.moc.count(for: Event.fetchRequest())
        XCTAssertEqual(count, 0)

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testEventCreation() {
        // Arrange
        let createdEventName = "DefaultName"
        let createdEventIndex = IndexPath(row: 0, section: 0)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: service.moc)

        // Act
        service.create(eventName: createdEventName)
        // Assert
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Save did not occur")

            self.service.fetch()

            XCTAssertEqual(self.service.dataAmount, 1)
            let eventFromModel = self.service.event(at: createdEventIndex)
            XCTAssertNotNil(eventFromModel)
            XCTAssertEqual(eventFromModel?.name, createdEventName)
            XCTAssertEqual(eventFromModel?.happenings?.count, 0)
        }
    }

    func testEventDeletion() {
        service.create(eventName: "ToBeDeleted")
        service.fetch()

        XCTAssertEqual(service.dataAmount, 1)

        let deletedCellIndex = IndexPath(row: 0, section: 0)
        let deletedEvent = service.event(at: deletedCellIndex)

        service.remove(event: deletedEvent!)
        service.fetch()

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testHappeningAddition() {
        let newEvent = service.create(eventName: "EventWithHappening")
        service.fetch()

        XCTAssertNil(newEvent.freshHappening)

        let point = service.addNewHappening(to: newEvent)
        XCTAssertEqual(newEvent.happenings?.count, 1)
        XCTAssertEqual(newEvent.freshHappening, point)

        let secondHappening = service.addNewHappening(to: newEvent)
        XCTAssertEqual(newEvent.happenings?.count, 2)
        XCTAssertEqual(newEvent.freshHappening, secondHappening)
    }

    func testFilledEventCreation() {
        let filledEvent = service.create(filledEventName: "Filled event", withDaysAmount: 18)

        coreDataStack.save(service.moc)

        XCTAssertEqual(filledEvent.name, "Filled event")
        XCTAssertEqual(filledEvent.daysSince, 19)
        XCTAssertNotEqual(filledEvent.weeksSince, 1)
        XCTAssertNotEqual(filledEvent.totalAmount, 0)
        XCTAssertNotEqual(filledEvent.dayAverage, 0)
        XCTAssertNotEqual(filledEvent.thisWeekTotal, 0)
        XCTAssertNotEqual(filledEvent.lastWeekTotal, 0)
        XCTAssertNotEqual(filledEvent.weekAverage, 0)
    }

    func testVisitedEventsAmount() {
        XCTAssertEqual(service.fetchVisitedEvents(), 0)
        let event = service.create(eventName: "Event")
        let event2 = service.create(eventName: "Event")
        let event3 = service.create(eventName: "Event")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedEvents(), 0)
        event.markAsVisited()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedEvents(), 1)
        event2.markAsVisited()
        event3.markAsVisited()
        XCTAssertEqual(service.fetchVisitedEvents(), 3)
    }

    func testHappeningsAmount() {
        XCTAssertEqual(service.fetchHappeningsCount(), 0)
        let event = service.create(eventName: "Event")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchHappeningsCount(), 0)
        event.addDefaultHappening()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchHappeningsCount(), 1)
        event.addDefaultHappening()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchHappeningsCount(), 2)
        let event2 = service.create(eventName: "Event2")
        event2.addDefaultHappening()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchHappeningsCount(), 3)
    }
}

class EventsListServiceDelegateMock: NSObject {
    var newHappeningEventIndex: IndexPath?

    private let testCase: XCTestCase
    private var expectation: XCTestExpectation?

    init(_ testCase: XCTestCase) { self.testCase = testCase }

    func expectNewHappeningNotification() {
        expectation = testCase.expectation(description: "Waiting for new point index")
    }
}
