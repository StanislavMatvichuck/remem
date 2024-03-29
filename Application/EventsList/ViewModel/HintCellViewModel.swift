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
        case .createEvent: return String(localizationId: "eventsList.hint.empty")
        case .swipeEvent: return String(localizationId: "eventsList.hint.firstHappening")
        case .checkDetails: return String(localizationId: "eventsList.hint.firstVisit")
        case .allDone: return String(localizationId: "eventsList.hint.permanentlyVisible")
        } }()

        highlighted = hint != .allDone
    }
}
