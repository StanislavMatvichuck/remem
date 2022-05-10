//
//  EntryDetailsServiceTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 10.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class EntryDetailsServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var entry: Entry!
    var sut: EntryDetailsService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let entry = Entry(context: context)

        coreDataStack = stack
        self.entry = entry
        entry.dateCreated = Date.now
        entry.name = "Entry"
        sut = EntryDetailsService(entry, stack: coreDataStack)
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

    func testMarkAsVisited() {
        XCTAssertEqual(entry.dateVisited, nil)

        sut.markAsVisited()

        XCTAssertNotNil(entry.dateVisited)
    }
}
