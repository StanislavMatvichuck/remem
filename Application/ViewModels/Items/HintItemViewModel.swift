//
//  HintItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Domain
import Foundation

protocol HintItemViewModelFactoring {
    func makeHintItemViewModel(events: [Event]) -> HintItemViewModel
}

struct HintItemViewModel: EventsListItemViewModeling {
    var identifier: String { "Hint" }

    let title: String
    let highlighted: Bool

    init(events: [Event]) {
        let hint = {
            if events.count == 0 { return HintState.empty }
            if events.filter({ $0.happenings.count > 0 }).count == 0 { return HintState.placeFirstMark }
            if events.filter({ $0.dateVisited != nil }).count == 0 { return HintState.pressMe }
            return HintState.swipeLeft
        }()

        title = hint.text
        highlighted = hint != .swipeLeft
    }

    static func == (lhs: HintItemViewModel, rhs: HintItemViewModel) -> Bool {
        lhs.title == rhs.title && lhs.highlighted == rhs.highlighted
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
