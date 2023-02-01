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

struct EventsListViewModel {
    let title = String(localizationId: "eventsList.title")

    private let today: DayIndex
    private let commander: EventsCommanding

    var sections: [[EventsListItemViewModel]]
    var numberOfSections: Int { sections.count }
    var renamedItem: EventItemViewModel?
    var inputVisible: Bool = false
    var inputContent: String = ""

    init(
        today: DayIndex,
        commander: EventsCommanding,
        sections: [[EventsListItemViewModel]]
    ) {
        self.today = today
        self.commander = commander
        self.sections = sections
    }

    func add(name: String) {
        commander.save(Event(name: name))
    }

    mutating func showInput() {
        inputVisible = true
    }

    func rows(inSection: Int) -> Int { sections[inSection].count }
    func itemViewModel(row: Int, section: Int) -> EventsListItemViewModel {
        sections[section][row]
    }
}
