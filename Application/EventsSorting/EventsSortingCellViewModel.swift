//
//  EventsSortingCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

extension EventsSorter {
    var title: String { switch self {
    case .alphabetical: String(localizationId: "eventsSorting.name")
    case .happeningsCountTotal: String(localizationId: "eventsSorting.total")
    case .manual(let identifiers): String(localizationId: "eventsSorting.manual")
    } }
}

struct EventsSortingCellViewModel {
    let title: String
    let isActive: Bool

    init(_ sorter: EventsSorter, activeSorter: EventsSorter? = nil) {
        title = sorter.title

        isActive = {
            if let activeSorter { activeSorter == sorter }
            else { false }
        }()
    }
}
