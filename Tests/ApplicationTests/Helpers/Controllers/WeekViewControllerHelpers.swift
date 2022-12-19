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

    static func make() -> WeekViewController {
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        let coordinator = CompositionRoot().coordinator
        let commander = EventsRepositoryFake(events: [event])
        let viewModel = WeekViewModel(
            today: today,
            event: event,
            coordinator: coordinator,
            commander: commander,
            factory: WeekItemViewModelFactory()
        )
        return WeekViewController(viewModel: viewModel)
    }
}

/// This type duplicates `CompositionRoot`. Must be removed later
struct WeekItemViewModelFactory: WeekItemViewModelFactoring {
    func makeWeekItemViewModel(day: Domain.DayComponents, today: Domain.DayComponents, happenings: [Domain.Happening]) -> Application.WeekItemViewModel {
        WeekItemViewModel(
            day: day,
            today: today,
            happenings: happenings
        )
    }
}
