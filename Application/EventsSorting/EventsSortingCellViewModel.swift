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
    case .name: String(localizationId: "eventsSorting.name")
    case .total: String(localizationId: "eventsSorting.total")
    case .dateCreated: String(localizationId: "eventsSorting.dateCreated")
    case .manual: String(localizationId: "eventsSorting.manual")
    } }
}

struct EventsSortingCellViewModel {
    let title: String
    let isActive: Bool

    let sorter: EventsSorter

    init(_ sorter: EventsSorter, activeSorter: EventsSorter? = nil) {
        self.sorter = sorter

        title = sorter.title

        isActive = {
            if let activeSorter { activeSorter == sorter }
            else { false }
        }()
    }
}
