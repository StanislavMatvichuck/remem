//
//  HappeningsListService.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class HappeningsListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!

    var event: Event!
    var sut: HappeningsListService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let event = Event(context: context)

        coreDataStack = stack
        self.event = event
        sut = HappeningsListService(event)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        event = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(event)
        XCTAssertNotNil(sut)
    }

    func testAmount() {
        sut.fetch()
        XCTAssertEqual(sut.count, 0)
        event.addDefaultHappening()
        sut.fetch()
        XCTAssertEqual(sut.count, 1)
        event.addDefaultHappening()
        event.addDefaultHappening()
        sut.fetch()
        XCTAssertEqual(sut.count, 3)
    }

    func testHappeningAt() {
        let createdHappeningIndexPath = IndexPath(row: 0, section: 0)
        let point = event.addDefaultHappening()

        XCTAssertNil(sut.point(at: createdHappeningIndexPath))
        sut.fetch()
        XCTAssertEqual(sut.point(at: createdHappeningIndexPath)?.dateCreated, point?.dateCreated)
    }

    /// Happenings must be sorted from new to old in a regular table
    func testSortingByDate() {
        let firstCreatedHappeningIndexPath = IndexPath(row: 1, section: 0)
        let secondCreatedHappeningIndexPath = IndexPath(row: 0, section: 0)

        let firstHappening = event.addDefaultHappening()
        let secondHappening = event.addDefaultHappening()

        sut.fetch()

        XCTAssertEqual(sut.point(at: firstCreatedHappeningIndexPath)?.dateCreated, firstHappening?.dateCreated)
        XCTAssertEqual(sut.point(at: secondCreatedHappeningIndexPath)?.dateCreated, secondHappening?.dateCreated)
    }
}
