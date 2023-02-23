//
//  WeekControllerHelpers.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.11.2022.
//

@testable import Application
import Domain
import XCTest

protocol WeekViewControllerTesting: AnyObject {
    var event: Event! { get set }
    var sut: WeekViewController! { get set }
    var commander: EventsCommanding! { get set }
}

extension WeekViewController {
    var firstDay: WeekItem { cell(at: IndexPath(row: 0, section: 0)) }

    func cell(at index: IndexPath) -> WeekItem {
        do {
            let cell = viewRoot.collection.dataSource?.collectionView(
                viewRoot.collection,
                cellForItemAt: index
            )

            return try XCTUnwrap(cell as? WeekItem)
        } catch { fatalError("error getting day") }
    }
}

extension WeekViewControllerTesting {
    func makeSutWithViewModelFactory(
        eventDateCreated: DayIndex = .referenceValue,
        today: DayIndex = .referenceValue
    ) {
        event = Event(name: "Event", dateCreated: eventDateCreated.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = container.makeWeekViewController()
        commander = container.weekViewModelUpdater
    }

    func clearSutAndViewModelFactory() {
        event = nil
        sut = nil
        commander = nil
    }

    func sendEventUpdatesToController() {
        commander.save(event)
    }
}
