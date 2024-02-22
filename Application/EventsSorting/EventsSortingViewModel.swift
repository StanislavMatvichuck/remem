//
//  EventsSortingViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

struct EventsSortingViewModel {
    private let factory: EventsSortingCellViewModelFactoring

    let count: Int
    let manualSortingEnabled: Bool
    let activeSorterIndex: Int
    let animateFrom: EventsSorter?

    init(
        _ factory: EventsSortingCellViewModelFactoring,
        manualSortingEnabled: Bool,
        activeSorterIndex: Int = 0,
        animateFrom: EventsSorter? = nil
    ) {
        self.factory = factory
        self.manualSortingEnabled = manualSortingEnabled
        self.activeSorterIndex = activeSorterIndex
        self.count = manualSortingEnabled ? 4 : 3
        self.animateFrom = animateFrom
    }

    func cell(at index: Int) -> EventsSortingCellViewModel {
        factory.makeEventsSortingCellViewModel(index: index)
    }
}
