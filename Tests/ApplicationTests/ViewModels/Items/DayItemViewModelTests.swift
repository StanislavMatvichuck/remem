//
//  DayItemViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

@testable import Application
import Domain
import XCTest

class DayItemViewModelTests: XCTestCase {
    private var sut: DayItemViewModel!

    override func setUp() {
        let created = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: created.date)
        let happening = event.addHappening(date: created.date)
        let commander = EventsRepositoryFake(events: [event])
        sut = DayItemViewModel(
            event: event,
            happening: happening,
            commander: commander
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
