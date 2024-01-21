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

    init(_ factory: EventsSortingCellViewModelFactoring, manualSortingEnabled: Bool) {
        self.factory = factory
        self.manualSortingEnabled = manualSortingEnabled
        self.count = manualSortingEnabled ? 3 : 2
    }

    func cell(at index: Int) -> EventsSortingCellViewModel {
        factory.makeEventsSortingCellViewModel(index: index)
    }
}
