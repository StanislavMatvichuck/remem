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
    case .manual: String(localizationId: "eventsSorting.manual")
    } }
}

struct EventsSortingCellViewModel {
    typealias TapHandler = (EventsSorter) -> Void
    let title: String
    let isActive: Bool

    private let sorter: EventsSorter
    private let handler: TapHandler?

    init(_ sorter: EventsSorter, activeSorter: EventsSorter? = nil, handler: TapHandler? = nil) {
        self.sorter = sorter
        self.handler = handler

        title = sorter.title

        isActive = {
            if let activeSorter { activeSorter == sorter }
            else { false }
        }()
    }

    func handleTap() { handler?(sorter) }
}
