//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

struct EventsListViewModel {
    // MARK: - Properties
    var renamedEvent: Event?
    var events: [Event]
    // MARK: - Init
    init(events: [Event]) {
        self.events = events
    }

    // EventsListViewModelState
    var count: Int { events.count }
    var isAddButtonHighlighted: Bool { events.count == 0 }
    var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .swipeLeft
    }

    func eventViewModel(at index: Int) -> EventViewModel? {
        if let event = event(at: index) {
            return EventViewModel(event: event)
        } else {
            return nil
        }
    }

    func event(at index: Int) -> Event? {
        guard index < events.count, index >= 0 else { return nil }
        return events[index]
    }
}

enum HintState: String {
    case empty
    case placeFirstMark
    case pressMe
    case swipeLeft

    var text: String? {
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
