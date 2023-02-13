//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel(events: [Event]) -> EventsListViewModel
}

protocol EventsListItemViewModeling: Equatable {
    var identifier: String { get }
}

extension EventsListItemViewModeling {
    func hasSame(identifier: String) -> Bool {
        self.identifier == identifier
    }
}

struct EventsListViewModel {
    let title = String(localizationId: "eventsList.title")

    private let today: DayIndex
    private let commander: EventsCommanding

    var renamedItem: EventItemViewModel?
    var inputVisible: Bool = false
    var inputContent: String = ""

    var items: [any EventsListItemViewModeling]

    init(
        today: DayIndex,
        commander: EventsCommanding,
        items: [any EventsListItemViewModeling]
    ) {
        self.today = today
        self.commander = commander
        self.items = items
    }

    func add(name: String) {
        commander.save(Event(name: name))
    }

    mutating func showInput() {
        inputVisible = true
    }

    subscript(identifier: String) -> Int? {
        for (index, item) in items.enumerated() {
            if item.hasSame(identifier: identifier) {
                return index
            }
        }
        return nil
//        let item = items.filter { $0.identifier == identifier }.first!
//        return item
//        let item = items[0]
//        return item
//        return FooterItemViewModel(eventsCount: 0)
    }
}
