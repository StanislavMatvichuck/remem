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
        let container = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController

        XCTAssertTrue(sut.view is WeekView)
    }

    func test_configuresCollection() {
        let container = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.collection.delegate)
    }

    func test_configuresViewModel() {
        let container = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: Event(name: "", dateCreated: DayIndex.referenceValue.date)))

        let sut = container.make() as! WeekViewController
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewRoot.viewModel)
    }

    func test_scrollsToLastPage() {
        let eventCreatedDate = DayIndex.referenceValue
        let container = WeekContainer(EventDetailsContainer(ApplicationContainer(
                mode: .injectedCurrentMoment,
                currentMoment: eventCreatedDate.adding(days: 7).date),
            event: Event(name: "", dateCreated: eventCreatedDate.date))
        )

        let sut = container.make() as! WeekViewController
        sut.view.translatesAutoresizingMaskIntoConstraints = true
        sut.view.frame = .screenSquare
        sut.view.layoutIfNeeded()

        XCTAssertEqual(sut.viewRoot.collection.contentOffset.x, .screenW)
    }

    func test_receivesUpdatesFromApplicationContainerCommander() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        appContainer.commander.save(event)

        let container = WeekContainer(EventDetailsContainer(appContainer, event: event))
        let sut = container.make() as! WeekViewController
        sut.loadViewIfNeeded()

        let firstIndex = IndexPath(row: 0, section: 0)
        let firstPage = sut.viewRoot.collection.dataSource?.collectionView(sut.viewRoot.collection, cellForItemAt: firstIndex) as! WeekPageView
        let firstPageTitle = firstPage.title.text

        XCTAssertEqual(firstPageTitle, "Week 1 total 0", "precondition")

        event.addHappening(date: DayIndex.referenceValue.date)
        appContainer.commander.save(event)

        let updatedFirstPage = sut.viewRoot.collection.dataSource?.collectionView(sut.viewRoot.collection, cellForItemAt: firstIndex) as! WeekPageView
        let updatedFirstPageTitle = updatedFirstPage.title.text

        XCTAssertEqual(updatedFirstPageTitle, "Week 1 total 1", "title changes because of added happening")
    }
}
