//
//  EventItemViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import DataLayer
import Domain
import XCTest

class EventItemViewModelTests: XCTestCase {
//    private var sut: EventItemViewModel!

//    override func setUp() {
//        super.setUp()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//    }

    func test_init() {
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        let sut = CompositionRoot(
            coreDataContainer: CoreDataStack.createContainer(inMemory: true)
        ).makeEventItemViewModel(event: event, today: today)

        XCTAssertNotNil(sut)
    }
}
