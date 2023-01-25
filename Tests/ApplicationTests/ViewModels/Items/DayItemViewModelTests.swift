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

        let root = ApplicationContainer(testingInMemoryMode: true)
        let listContainer = root.makeContainer()
        let eventDetailsContainer = listContainer.makeContainer(event: event, today: created)
        let dayDetailsContainer = eventDetailsContainer.makeContainer(day: created)

        sut = dayDetailsContainer.makeViewModel(
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
