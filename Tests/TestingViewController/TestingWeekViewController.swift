//
//  WeekControllerHelpers.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == WeekViewController {
    func make() {
        event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: DayIndex.referenceValue)
        sut = WeekContainer(parent: container).make() as? WeekViewController
        sut.loadViewIfNeeded()
    }

    var firstDay: WeekItem { cell(at: IndexPath(row: 0, section: 0)) }

    func cell(at index: IndexPath) -> WeekItem {
        do {
            let cell = sut.viewRoot.collection.dataSource?.collectionView(
                sut.viewRoot.collection,
                cellForItemAt: index
            )

            return try XCTUnwrap(cell as? WeekItem)
        } catch { fatalError("error getting day") }
    }

    func sendEventUpdatesToController() {
        sut.update()
    }
}
