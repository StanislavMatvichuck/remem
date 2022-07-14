//
//  CountableEventDetailsServiceTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 10.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class CountableEventDetailsServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var countableEvent: CountableEvent!
    var sut: CountableEventDetailsService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let countableEvent = CountableEvent(context: context)

        coreDataStack = stack
        self.countableEvent = countableEvent
        countableEvent.dateCreated = Date.now
        countableEvent.name = "CountableEvent"
        sut = CountableEventDetailsService(countableEvent, stack: coreDataStack)
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

    func testMarkAsVisited() {
        XCTAssertEqual(countableEvent.dateVisited, nil)

        sut.markAsVisited()

        XCTAssertNotNil(countableEvent.dateVisited)
    }
}
