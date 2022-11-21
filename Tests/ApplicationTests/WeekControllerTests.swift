//
//  WeekControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekControllerTests: XCTestCase {
    func test_empty_displays21Columns() {
        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()
        let sut = WeekController(event: event, useCase: useCase)

        XCTAssertEqual(sut.viewRoot.collection.numberOfItems(inSection: 0), 21)
    }

    func test_empty_hasTodayColumn() {
        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()
        let sut = WeekController(event: event, useCase: useCase)

        let todays = sut.viewModel.weekCellViewModels.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_tap_presentsDayController() {}
}
