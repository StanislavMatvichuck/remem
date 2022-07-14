//
//  HintsManagerTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 02.05.2022.
//

import CoreData
import Foundation
@testable import Remem
import XCTest

class HintsManagerTests: XCTestCase {
    var service: CountableEventsListService!
    var sut: HintsManager!

    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataStack()
        let moc = CoreDataStack.createContainer(inMemory: true).viewContext
        service = CountableEventsListService(moc: moc, stack: coreDataStack)
        sut = HintsManager(service: service)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        service = nil
    }

    func testInit() {
        XCTAssertNotNil(service, "Service must be created")
        XCTAssertNotNil(sut, "HintsManager class must be created")
    }

    func testEmptyState() {
        XCTAssertEqual(HintsManager.State.empty, sut.fetchState())
    }

    func testFirstMarkState() {
        service.create(countableEventName: "CountableEvent")
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .placeFirstMark)
    }

    func testPressMeState() {
        let countableEvent = service.create(countableEventName: "CountableEvent")
        countableEvent.addDefaultCountableEventHappeningDescription()
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .pressMe)
    }

    func testNoHintsState() {
        let countableEvent = service.create(countableEventName: "CountableEvent")
        countableEvent.addDefaultCountableEventHappeningDescription()
        countableEvent.dateVisited = Date.now
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .noHints)
    }
}
