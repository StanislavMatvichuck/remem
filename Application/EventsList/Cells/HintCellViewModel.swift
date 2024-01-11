//
//  HintItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Domain
import Foundation

struct HintCellViewModel: EventsListItemViewModeling {
    enum HintState {
        case addFirstEvent
        case swipeFirstTime
        case pressMe
        case permanentlyVisible

        var text: String {
            switch self {
            case .addFirstEvent: return String(localizationId: "eventsList.hint.empty")
            case .swipeFirstTime: return String(localizationId: "eventsList.hint.firstHappening")
            case .pressMe: return String(localizationId: "eventsList.hint.firstVisit")
            case .permanentlyVisible: return String(localizationId: "eventsList.hint.permanentlyVisible")
            }
        }
    }

    var identifier: String { "Hint" }

    let title: String
    let highlighted: Bool

    init(events: [Event]) {
        let hint: HintState = {
            if events.count == 0 { return .addFirstEvent }
            if events.filter({ $0.happenings.count > 0 }).count == 0 { return .swipeFirstTime }
            if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
            return .permanentlyVisible
        }()

        title = hint.text
        highlighted = hint != .permanentlyVisible
    }

    static func == (lhs: HintCellViewModel, rhs: HintCellViewModel) -> Bool {
        lhs.title == rhs.title && lhs.highlighted == rhs.highlighted
    }
}
