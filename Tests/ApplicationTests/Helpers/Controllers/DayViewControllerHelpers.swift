//
//  DayDetailsControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

extension DayViewController {
    var table: UITableView { viewRoot.happenings }
    var firstIndex: IndexPath { IndexPath(row: 0, section: 0) }
    var happeningsAmount: Int { table.numberOfRows(inSection: 0) }

    func happening(at index: IndexPath) -> DayItem {
        do {
            let cell = table.dataSource?.tableView(table, cellForRowAt: index)
            return try XCTUnwrap(cell as? DayItem)
        } catch { fatalError("happening getting error") }
    }

    static func make(
        event: Event = Event(name: "Event"),
        day: DayComponents = DayComponents(date: .now)
    ) -> DayViewController {
        let decoratedCommander = EventsCommandingDayViewModelUpdatingDecorator(decoratedInterface: EventsRepositoryFake(events: [event]))
        let viewModel = DayViewModelFactory(commander: decoratedCommander).makeDayViewModel(event: event, day: day)
        let sut = DayViewController(viewModel: viewModel)

        sut.loadViewIfNeeded()
        decoratedCommander.addUpdateReceiver(sut)

        _ = UINavigationController(rootViewController: sut)

        putInViewHierarchy(sut)

        return sut
    }
}

/// This type duplicates `CompositionRoot`. Must be removed later
struct DayItemViewModelFactory: DayItemViewModelFactoring {
    let commander: EventsCommanding

    init(commander: EventsCommanding) {
        self.commander = commander
    }

    func makeDayItemViewModel(event: Event, happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: commander
        )
    }
}

struct DayViewModelFactory: DayViewModelFactoring {
    let commander: EventsCommanding

    init(commander: EventsCommanding) {
        self.commander = commander
    }

    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(
            day: day,
            event: event,
            commander: commander,
            itemsFactory: DayItemViewModelFactory(commander: commander),
            selfFactory: self
        )
    }
}
