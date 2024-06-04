//
//  HintItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Domain
import Foundation

struct HintCellViewModel {
    let title: String
    let highlighted: Bool

    init(hint: EventsList.Hint) {
        title = { switch hint {
        case .createEvent: return String(localizationId: localizationIdEventsListHintEmpty)
        case .swipeEvent: return String(localizationId: localizationIdEventsListHintFirstHappening)
        case .checkDetails: return String(localizationId: localizationIdEventsListHintFirstVisit)
        case .allDone: return String(localizationId: localizationIdEventsListHintPermanent)
        } }()

        highlighted = hint != .allDone
    }
}
