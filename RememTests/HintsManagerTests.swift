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
    var service: EntriesListService!
    var sut: HintsManager!

    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataStack()
        let moc = CoreDataStack.createContainer(inMemory: true).viewContext
        service = EntriesListService(moc: moc, stack: coreDataStack)
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
        service.create(entryName: "Entry")
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .placeFirstMark)
    }

    func testPressMeState() {
        let entry = service.create(entryName: "Entry")
        entry.addDefaultPoint()
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .pressMe)
    }

    func testNoHintsState() {
        let entry = service.create(entryName: "Entry")
        entry.addDefaultPoint()
        entry.dateVisited = Date.now
        service.fetch()
        sut = HintsManager(service: service)
        XCTAssertEqual(sut.fetchState(), .noHints)
    }
}
