//
//  DayItemViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

@testable import Application
import DataLayer
import Domain
import XCTest

class DayItemViewModelTests: XCTestCase {
    private var sut: DayItemViewModel!

    override func setUp() {
        let created = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: created.date)
        let happening = event.addHappening(date: created.date)

        sut = CompositionRoot(
            coreDataContainer: CoreDataStack.createContainer(inMemory: true)
        ).makeDayItemViewModel(
            event: event,
            happening: happening
        )

        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }
}
