//
//  NewWeekViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

@testable import Application
import Domain
import XCTest

final class NewWeekViewControllerTests: XCTestCase {
    func test_showsNewWeekView() {
        let container = NewWeekContainer(
            EventDetailsContainer(parent:
                EventsListContainer(parent:
                    ApplicationContainer(mode: .unitTest)),
                event: Event(name: ""),
                today: .referenceValue),
            today: DayIndex.referenceValue.date)

        let sut = container.make() as! NewWeekViewController

        XCTAssertTrue(sut.view is NewWeekView)
    }

    func test_configuresCollection() {
        let container = NewWeekContainer(
            EventDetailsContainer(parent:
                EventsListContainer(parent:
                    ApplicationContainer(mode: .unitTest)),
                event: Event(name: ""),
                today: .referenceValue),
            today: DayIndex.referenceValue.date)

        let sut = container.make() as! NewWeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.collection.delegate)
    }

    func test_configuresViewModel() {
        let container = NewWeekContainer(
            EventDetailsContainer(parent:
                EventsListContainer(parent:
                    ApplicationContainer(mode: .unitTest)),
                event: Event(name: ""),
                today: .referenceValue),
            today: DayIndex.referenceValue.date)

        let sut = container.make() as! NewWeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.viewModel)
    }
}
