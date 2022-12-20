//
//  WeekControllerHelpers.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.11.2022.
//

@testable import Application
import DataLayer
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
        return CompositionRoot(
            coreDataContainer: CoreDataStack.createContainer(inMemory: true)
        ).makeWeekViewController(
            event: event,
            today: today
        )
    }
}

/// This type duplicates `CompositionRoot`. Must be removed later
struct WeekItemViewModelFactory: WeekItemViewModelFactoring {
    func makeWeekItemViewModel(
        event: Event,
        today: DayComponents,
        day: DayComponents
    ) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: CompositionRoot().coordinator
        )
    }
}

struct WeekViewModelFactory: WeekViewModelFactoring {
    let coordinator: Coordinating
    let commander: EventsCommanding

    init(coordinator: Coordinating, commander: EventsCommanding) {
        self.coordinator = coordinator
        self.commander = commander
    }

    func makeWeekViewModel(event: Event, today: DayComponents) -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: coordinator,
            commander: commander,
            itemsFactory: WeekItemViewModelFactory(),
            selfFactory: self
        )
    }
}
