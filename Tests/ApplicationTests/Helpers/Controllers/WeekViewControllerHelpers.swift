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
    var firstDay: WeekItem { day(at: IndexPath(row: 0, section: 0)) }

    func day(at index: IndexPath) -> WeekItem {
        do {
            let cell = viewRoot.collection.dataSource?.collectionView(
                viewRoot.collection,
                cellForItemAt: index
            )

            return try XCTUnwrap(cell as? WeekItem)
        } catch { fatalError("error getting day") }
    }

    static func make() -> (sut: WeekViewController, coordinator: Coordinating) {
        let coordinator = CompositionRoot().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        return (
            sut: WeekViewController(
                today: today,
                event: event,
                useCase: useCase,
                coordinator: coordinator
            ),
            coordinator: coordinator
        )
    }
}
