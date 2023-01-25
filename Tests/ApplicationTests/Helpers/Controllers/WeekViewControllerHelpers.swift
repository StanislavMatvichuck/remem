//
//  WeekControllerHelpers.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.11.2022.
//

@testable import Application
import Domain
import XCTest

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

    static func make() -> WeekViewController {
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)

        let container = ApplicationContainer(testingInMemoryMode: true)
        let listContainer = container.makeContainer()
        let eventDetailsContainer = listContainer.makeContainer(event: event, today: today)
        return eventDetailsContainer.makeWeekViewController()
    }
}
