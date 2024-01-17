//
//  EventsSortingViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

struct EventsSortingViewModel {
    private static let sorters: [EventsSorter] = EventsSorter.allCases

    let count = sorters.count
    private let activeSorter: EventsSorter?

    init(_ activeSorter: EventsSorter? = nil) { self.activeSorter = activeSorter }

    func cell(at index: Int) -> EventsSortingCellViewModel {
        EventsSortingCellViewModel(Self.sorters[index], activeSorter: activeSorter)
    }
}
