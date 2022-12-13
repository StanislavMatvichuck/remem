//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

struct EventsListViewModel {
    typealias ItemViewModelFactory = (_: Event, _: DayComponents) -> EventItemViewModel

    let events: [Event]
    let today: DayComponents
    let items: [EventItemViewModel]
    let factory: ItemViewModelFactory
    let commander: EventsCommanding
    let hint: String
    var renamedItem: EventItemViewModel?

    init(
        events: [Event],
        today: DayComponents,
        itemViewModelFactory: @escaping ItemViewModelFactory,
        commander: EventsCommanding
    ) {
        self.events = events
        self.today = today

        self.commander = commander
        factory = itemViewModelFactory

        hint = {
            if events.count == 0 { return HintState.empty.text }
            if events.filter({ $0.happenings.count > 0 }).count == 0 { return HintState.placeFirstMark.text }
            if events.filter({ $0.dateVisited != nil }).count == 0 { return HintState.pressMe.text }
            return HintState.swipeLeft.text
        }()

        items = events.map { event in
            itemViewModelFactory(event, today)
        }
    }

    func add(name: String) {
        commander.save(Event(name: name))
    }
}

enum HintState: String {
    case empty
    case placeFirstMark
    case pressMe
    case swipeLeft

    var text: String {
        switch self {
        case .empty:
            return String(localizationId: "eventsList.hint.empty")
        case .placeFirstMark:
            return String(localizationId: "eventsList.hint.firstHappening")
        case .pressMe:
            return String(localizationId: "eventsList.hint.firstVisit")
        case .swipeLeft:
            return String(localizationId: "eventsList.hint.swipeLeft")
        }
    }
}
