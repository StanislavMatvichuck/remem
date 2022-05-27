//
//  RememTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 15.04.2022.
//

@testable import Remem

import CoreData
import XCTest

class EntriesListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var service: EntriesListService!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        service = EntriesListService(moc: container.viewContext, stack: coreDataStack)
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
        let count = try? service.moc.count(for: Entry.fetchRequest())
        XCTAssertEqual(count, 0)

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testEntryCreation() {
        // Arrange
        let createdEntryName = "DefaultName"
        let createdEntryIndex = IndexPath(row: 0, section: 0)

        expectation(forNotification: .NSManagedObjectContextDidSave, object: service.moc)

        // Act
        service.create(entryName: createdEntryName)
        // Assert
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Save did not occur")

            self.service.fetch()

            XCTAssertEqual(self.service.dataAmount, 1)
            let entryFromModel = self.service.entry(at: createdEntryIndex)
            XCTAssertNotNil(entryFromModel)
            XCTAssertEqual(entryFromModel?.name, createdEntryName)
            XCTAssertEqual(entryFromModel?.points?.count, 0)
        }
    }

    func testEntryDeletion() {
        service.create(entryName: "ToBeDeleted")
        service.fetch()

        XCTAssertEqual(service.dataAmount, 1)

        let deletedCellIndex = IndexPath(row: 0, section: 0)
        let deletedEntry = service.entry(at: deletedCellIndex)

        service.remove(entry: deletedEntry!)
        service.fetch()

        XCTAssertEqual(service.dataAmount, 0)
    }

    func testPointAddition() {
        let newEntry = service.create(entryName: "EntryWithPoint")
        service.fetch()

        XCTAssertNil(newEntry.freshPoint)

        let point = service.addNewPoint(to: newEntry)
        XCTAssertEqual(newEntry.points?.count, 1)
        XCTAssertEqual(newEntry.freshPoint, point)

        let secondPoint = service.addNewPoint(to: newEntry)
        XCTAssertEqual(newEntry.points?.count, 2)
        XCTAssertEqual(newEntry.freshPoint, secondPoint)
    }

    func testFilledEntryCreation() {
        let filledEntry = service.create(filledEntryName: "Filled entry", withDaysAmount: 18)

        coreDataStack.save(service.moc)

        XCTAssertEqual(filledEntry.name, "Filled entry")
        XCTAssertEqual(filledEntry.daysSince, 19)
        XCTAssertNotEqual(filledEntry.weeksSince, 1)
        XCTAssertNotEqual(filledEntry.totalAmount, 0)
        XCTAssertNotEqual(filledEntry.dayAverage, 0)
        XCTAssertNotEqual(filledEntry.thisWeekTotal, 0)
        XCTAssertNotEqual(filledEntry.lastWeekTotal, 0)
        XCTAssertNotEqual(filledEntry.weekAverage, 0)
    }

    func testVisitedEntriesAmount() {
        XCTAssertEqual(service.fetchVisitedEntries(), 0)
        let entry = service.create(entryName: "Entry")
        let entry2 = service.create(entryName: "Entry")
        let entry3 = service.create(entryName: "Entry")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedEntries(), 0)
        entry.markAsVisited()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchVisitedEntries(), 1)
        entry2.markAsVisited()
        entry3.markAsVisited()
        XCTAssertEqual(service.fetchVisitedEntries(), 3)
    }

    func testPointsAmount() {
        XCTAssertEqual(service.fetchPointsCount(), 0)
        let entry = service.create(entryName: "Entry")
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchPointsCount(), 0)
        entry.addDefaultPoint()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchPointsCount(), 1)
        entry.addDefaultPoint()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchPointsCount(), 2)
        let entry2 = service.create(entryName: "Entry2")
        entry2.addDefaultPoint()
        coreDataStack.save(service.moc)
        XCTAssertEqual(service.fetchPointsCount(), 3)
    }
}

class EntriesListServiceDelegateMock: NSObject {
    var newPointEntryIndex: IndexPath?

    private let testCase: XCTestCase
    private var expectation: XCTestExpectation?

    init(_ testCase: XCTestCase) { self.testCase = testCase }

    func expectNewPointNotification() {
        expectation = testCase.expectation(description: "Waiting for new point index")
    }
}
