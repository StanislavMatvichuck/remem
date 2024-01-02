//
//  WeekViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekViewControllerTests: XCTestCase {
    func test_showsWeekView() {
        let container = WeekContainer(
            EventDetailsContainer(
                EventsListContainer(ApplicationContainer(mode: .unitTest)),
                event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController

        XCTAssertTrue(sut.view is WeekView)
    }

    func test_configuresCollection() {
        let container = WeekContainer(EventDetailsContainer(
            EventsListContainer(ApplicationContainer(mode: .unitTest)),
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.collection.delegate)
    }

    func test_configuresViewModel() {
        let container = WeekContainer(
            EventDetailsContainer(EventsListContainer(ApplicationContainer(mode: .unitTest)),
                                  event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.viewModel)
    }

    func test_scrollsToLastPage() {
        let eventCreatedDate = DayIndex.referenceValue
        let container = WeekContainer(EventDetailsContainer(
            EventsListContainer(ApplicationContainer(
                mode: .injectedCurrentMoment,
                currentMoment: eventCreatedDate.adding(days: 7).date)),
            event: Event(name: "", dateCreated: eventCreatedDate.date)))

        let sut = container.make() as! WeekViewController
        sut.view.translatesAutoresizingMaskIntoConstraints = true
        sut.view.frame = .screenSquare
        sut.view.layoutIfNeeded()

        XCTAssertEqual(sut.viewRoot.collection.contentOffset.x, .screenW)
    }
}
