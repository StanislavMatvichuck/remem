//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel() -> EventsListViewModel
}

struct EventsListViewModel: EventDependantViewModel {
    let title = String(localizationId: "eventsList.title")
    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    private let events: [Event]
    private let today: DayComponents
    private let selfFactory: EventsListViewModelFactoring
    private let commander: EventsCommanding

    var sections: [[EventsListItemViewModel]]
    var numberOfSections: Int { sections.count }
    var renamedItem: EventItemViewModel?
    var inputVisible: Bool = false
    var inputContent: String = ""

    init(
        events: [Event],
        today: DayComponents,
        commander: EventsCommanding,
        sections: [[EventsListItemViewModel]],
        selfFactory: EventsListViewModelFactoring
    ) {
        self.events = events
        self.today = today
        self.commander = commander
        self.sections = sections
        self.selfFactory = selfFactory
    }

    func add(name: String) {
        commander.save(Event(name: name))
    }

    mutating func showInput() {
        inputVisible = true
    }

    var eventId: String { "eventsList" }

    func copy(newEvent: Event) -> EventsListViewModel {
        selfFactory.makeEventsListViewModel()
    }

    func rows(inSection: Int) -> Int { sections[inSection].count }
    func itemViewModel(row: Int, section: Int) -> EventsListItemViewModel {
        sections[section][row]
    }
}
