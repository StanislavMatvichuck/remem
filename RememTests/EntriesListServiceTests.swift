//
//  RememTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 15.04.2022.
//

@testable import Remem

import CoreData
import XCTest

class CountableEventsListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var service: CountableEventsListService!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        service = CountableEventsListService(moc: container.viewContext, stack: coreDataStack)
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
        let count = try? service.moc.count(for: CountableEvent.fetchRequest())
        XCTAssertEqual(count, 0)

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testCountableEventCreation() {
        // Arrange
        let createdCountableEventName = "DefaultName"
        let createdCountableEventIndex = IndexPath(row: 0, section: 0)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: service.moc)

        // Act
        service.create(countableEventName: createdCountableEventName)
        // Assert
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Save did not occur")

            self.service.fetch()

            XCTAssertEqual(self.service.dataAmount, 1)
            let countableEventFromModel = self.service.countableEvent(at: createdCountableEventIndex)
            XCTAssertNotNil(countableEventFromModel)
            XCTAssertEqual(countableEventFromModel?.name, createdCountableEventName)
            XCTAssertEqual(countableEventFromModel?.happenings?.count, 0)
        }
    }

    func testCountableEventDeletion() {
        service.create(countableEventName: "ToBeDeleted")
        service.fetch()

        XCTAssertEqual(service.dataAmount, 1)

        let deletedCellIndex = IndexPath(row: 0, section: 0)
        let deletedCountableEvent = service.countableEvent(at: deletedCellIndex)

        service.remove(countableEvent: deletedCountableEvent!)
        service.fetch()

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testCountableEventHappeningDescriptionAddition() {
        let newCountableEvent = service.create(countableEventName: "CountableEventWithCountableEventHappeningDescription")
        service.fetch()

        XCTAssertNil(newCountableEvent.freshCountableEventHappeningDescription)

        let point = service.addNewCountableEventHappeningDescription(to: newCountableEvent)
        XCTAssertEqual(newCountableEvent.happenings?.count, 1)
        XCTAssertEqual(newCountableEvent.freshCountableEventHappeningDescription, point)

        let secondCountableEventHappeningDescription = service.addNewCountableEventHappeningDescription(to: newCountableEvent)
        XCTAssertEqual(newCountableEvent.happenings?.count, 2)
        XCTAssertEqual(newCountableEvent.freshCountableEventHappeningDescription, secondCountableEventHappeningDescription)
    }

    func testFilledCountableEventCreation() {
        let filledCountableEvent = service.create(filledCountableEventName: "Filled countableEvent", withDaysAmount: 18)

        coreDataStack.save(service.moc)

        XCTAssertEqual(filledCountableEvent.name, "Filled countableEvent")
        XCTAssertEqual(filledCountableEvent.daysSince, 19)
        XCTAssertNotEqual(filledCountableEvent.weeksSince, 1)
        XCTAssertNotEqual(filledCountableEvent.totalAmount, 0)
        XCTAssertNotEqual(filledCountableEvent.dayAverage, 0)
        XCTAssertNotEqual(filledCountableEvent.thisWeekTotal, 0)
        XCTAssertNotEqual(filledCountableEvent.lastWeekTotal, 0)
        XCTAssertNotEqual(filledCountableEvent.weekAverage, 0)
    }

    func testVisitedCountableEventsAmount() {
        XCTAssertEqual(service.fetchVisitedCountableEvents(), 0)
        let countableEvent = service.create(countableEventName: "CountableEvent")
        let countableEvent2 = service.create(countableEventName: "CountableEvent")
        let countableEvent3 = service.create(countableEventName: "CountableEvent")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedCountableEvents(), 0)
        countableEvent.markAsVisited()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedCountableEvents(), 1)
        countableEvent2.markAsVisited()
        countableEvent3.markAsVisited()
        XCTAssertEqual(service.fetchVisitedCountableEvents(), 3)
    }

    func testCountableEventHappeningDescriptionsAmount() {
        XCTAssertEqual(service.fetchCountableEventHappeningDescriptionsCount(), 0)
        let countableEvent = service.create(countableEventName: "CountableEvent")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchCountableEventHappeningDescriptionsCount(), 0)
        countableEvent.addDefaultCountableEventHappeningDescription()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchCountableEventHappeningDescriptionsCount(), 1)
        countableEvent.addDefaultCountableEventHappeningDescription()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchCountableEventHappeningDescriptionsCount(), 2)
        let countableEvent2 = service.create(countableEventName: "CountableEvent2")
        countableEvent2.addDefaultCountableEventHappeningDescription()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchCountableEventHappeningDescriptionsCount(), 3)
    }
}

class CountableEventsListServiceDelegateMock: NSObject {
    var newCountableEventHappeningDescriptionCountableEventIndex: IndexPath?

    private let testCase: XCTestCase
    private var expectation: XCTestExpectation?

    init(_ testCase: XCTestCase) { self.testCase = testCase }

    func expectNewCountableEventHappeningDescriptionNotification() {
        expectation = testCase.expectation(description: "Waiting for new point index")
    }
}
