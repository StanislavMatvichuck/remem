//
//  EventDetailsServiceTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 10.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class EventDetailsServiceTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var event: Event!
    var sut: EventDetailsService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let event = Event(context: context)

        coreDataStack = stack
        self.event = event
        event.dateCreated = Date.now
        event.name = "Event"
        sut = EventDetailsService(event, stack: coreDataStack)
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

    func testMarkAsVisited() {
        XCTAssertEqual(event.dateVisited, nil)

        sut.markAsVisited()

        XCTAssertNotNil(event.dateVisited)
    }
}
