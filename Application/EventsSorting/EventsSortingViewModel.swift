//
//  EventsSortingViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

struct EventsSortingViewModel {
    static let count = EventsSorter.allCases.count
    
    private let factory: EventsSortingCellViewModelFactoring

    init(_ factory: EventsSortingCellViewModelFactoring) { self.factory = factory }

    func cell(at index: Int) -> EventsSortingCellViewModel {
        factory.makeEventsSortingCellViewModel(index: index)
    }
}
