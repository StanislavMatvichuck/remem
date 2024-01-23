//
//  EventCreationContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventCreationContainerTests: XCTestCase {
    func test_init() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let sut = EventCreationContainer(parent: appContainer)
    }

    func test_makesEventCreationController() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let sut: ControllerFactoring = EventCreationContainer(parent: appContainer)

        XCTAssertNotNil(sut.make() as? EventCreationController)
    }

    func test_makesEventCreationViewModel() {
        let appContainer = ApplicationContainer(mode: .unitTest)
        let sut: EventCreationViewModelFactoring = EventCreationContainer(parent: appContainer)

        XCTAssertNotNil(sut.makeEventCreationViewModel())
    }
}
