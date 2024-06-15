//
//  EventsSortingCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

extension EventsList.Ordering {
    var title: String { switch self {
    case .name: String(localizationId: localizationIdOrderingName)
    case .total: String(localizationId: localizationIdOrderingTotal)
    case .dateCreated: String(localizationId: localizationIdOrderingDateCreated)
    case .manual: String(localizationId: localizationIdOrderingManual)
    } }
}

struct EventsSortingCellViewModel {
    let title: String
    let isActive: Bool

    let sorter: EventsList.Ordering

    init(_ sorter: EventsList.Ordering, activeSorter: EventsList.Ordering? = nil) {
        self.sorter = sorter

        title = sorter.title

        isActive = {
            if let activeSorter { activeSorter == sorter }
            else { false }
        }()
    }
}
