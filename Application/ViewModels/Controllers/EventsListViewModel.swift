//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

protocol EventItemViewModelFactory {
    func makeEventItemViewModel(event: Event, today: DayComponents) -> EventItemViewModel
}

struct EventsListViewModel {
    private let events: [Event]
    private let today: DayComponents
    private let factory: EventItemViewModelFactory
    private let commander: EventsCommanding

    let title = String(localizationId: "eventsList.title")
    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    let hint: String
    let items: [EventItemViewModel]
    var renamedItem: EventItemViewModel?

    init(
        events: [Event],
        today: DayComponents,
        factory: EventItemViewModelFactory,
        commander: EventsCommanding
    ) {
        self.events = events
        self.today = today
        self.factory = factory
        self.commander = commander

        hint = {
            if events.count == 0 { return HintState.empty.text }
            if events.filter({ $0.happenings.count > 0 }).count == 0 { return HintState.placeFirstMark.text }
            if events.filter({ $0.dateVisited != nil }).count == 0 { return HintState.pressMe.text }
            return HintState.swipeLeft.text
        }()

        items = events.map { event in
            factory.makeEventItemViewModel(event: event, today: today)
        }
    }

    func add(name: String) {
        commander.save(Event(name: name))
    }
}

enum HintState {
    case empty
    case placeFirstMark
    case pressMe
    case swipeLeft

    var text: String {
        switch self {
        case .empty: return String(localizationId: "eventsList.hint.empty")
        case .placeFirstMark: return String(localizationId: "eventsList.hint.firstHappening")
        case .pressMe: return String(localizationId: "eventsList.hint.firstVisit")
        case .swipeLeft: return String(localizationId: "eventsList.hint.swipeLeft")
        }
    }
}
