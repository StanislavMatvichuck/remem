//
//  EntryPointsListService.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class EntryPointsListServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!

    var entry: Entry!
    var sut: EntryPointsListService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let entry = Entry(context: context)

        coreDataStack = stack
        self.entry = entry
        sut = EntryPointsListService(entry)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        entry = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(entry)
        XCTAssertNotNil(sut)
    }

    func testAmount() {
        sut.fetch()
        XCTAssertEqual(sut.count, 0)
        entry.addDefaultPoint()
        sut.fetch()
        XCTAssertEqual(sut.count, 1)
        entry.addDefaultPoint()
        entry.addDefaultPoint()
        sut.fetch()
        XCTAssertEqual(sut.count, 3)
    }

    func testPointAt() {
        let createdPointIndexPath = IndexPath(row: 0, section: 0)
        let point = entry.addDefaultPoint()

        XCTAssertNil(sut.point(at: createdPointIndexPath))
        sut.fetch()
        XCTAssertEqual(sut.point(at: createdPointIndexPath)?.dateCreated, point?.dateCreated)
    }

    /// Points must be sorted from new to old in a regular table
    func testSortingByDate() {
        let firstCreatedPointIndexPath = IndexPath(row: 1, section: 0)
        let secondCreatedPointIndexPath = IndexPath(row: 0, section: 0)

        let firstPoint = entry.addDefaultPoint()
        let secondPoint = entry.addDefaultPoint()

        sut.fetch()

        XCTAssertEqual(sut.point(at: firstCreatedPointIndexPath)?.dateCreated, firstPoint?.dateCreated)
        XCTAssertEqual(sut.point(at: secondCreatedPointIndexPath)?.dateCreated, secondPoint?.dateCreated)
    }
}
