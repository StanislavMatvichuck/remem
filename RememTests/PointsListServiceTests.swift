//
//  CountableEventHappeningDescriptionsListService.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class CountableEventHappeningDescriptionsListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!

    var countableEvent: CountableEvent!
    var sut: CountableEventHappeningDescriptionsListService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let countableEvent = CountableEvent(context: context)

        coreDataStack = stack
        self.countableEvent = countableEvent
        sut = CountableEventHappeningDescriptionsListService(countableEvent)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        countableEvent = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(countableEvent)
        XCTAssertNotNil(sut)
    }

    func testAmount() {
        sut.fetch()
        XCTAssertEqual(sut.count, 0)
        countableEvent.addDefaultCountableEventHappeningDescription()
        sut.fetch()
        XCTAssertEqual(sut.count, 1)
        countableEvent.addDefaultCountableEventHappeningDescription()
        countableEvent.addDefaultCountableEventHappeningDescription()
        sut.fetch()
        XCTAssertEqual(sut.count, 3)
    }

    func testCountableEventHappeningDescriptionAt() {
        let createdCountableEventHappeningDescriptionIndexPath = IndexPath(row: 0, section: 0)
        let point = countableEvent.addDefaultCountableEventHappeningDescription()

        XCTAssertNil(sut.point(at: createdCountableEventHappeningDescriptionIndexPath))
        sut.fetch()
        XCTAssertEqual(sut.point(at: createdCountableEventHappeningDescriptionIndexPath)?.dateCreated, point?.dateCreated)
    }

    /// CountableEventHappeningDescriptions must be sorted from new to old in a regular table
    func testSortingByDate() {
        let firstCreatedCountableEventHappeningDescriptionIndexPath = IndexPath(row: 1, section: 0)
        let secondCreatedCountableEventHappeningDescriptionIndexPath = IndexPath(row: 0, section: 0)

        let firstCountableEventHappeningDescription = countableEvent.addDefaultCountableEventHappeningDescription()
        let secondCountableEventHappeningDescription = countableEvent.addDefaultCountableEventHappeningDescription()

        sut.fetch()

        XCTAssertEqual(sut.point(at: firstCreatedCountableEventHappeningDescriptionIndexPath)?.dateCreated, firstCountableEventHappeningDescription?.dateCreated)
        XCTAssertEqual(sut.point(at: secondCreatedCountableEventHappeningDescriptionIndexPath)?.dateCreated, secondCountableEventHappeningDescription?.dateCreated)
    }
}
