//
//  DayDetailsContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

@testable import Application
import Domain
import XCTest

final class DayDetailsContainerTests: XCTestCase {
    var sut: DayDetailsContainer!
    weak var weakSut: DayDetailsContainer?

    override func setUp() {
        super.setUp()
        let day = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        sut = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)
            .makeContainer(day: day)
        weakSut = sut
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()

        XCTAssertNil(weakSut)
    }

    func test_viewController_holdsStrongRef() {
        var vc: DayDetailsViewController? = sut.makeController()
        print("controller is held")
        vc = nil
        print("controller is freed")
    }
}
