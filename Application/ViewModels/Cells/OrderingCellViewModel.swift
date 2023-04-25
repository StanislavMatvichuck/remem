//
//  OrderingItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import Foundation

struct OrderingCellViewModel: EventsListItemViewModeling {
    struct Item: Equatable {
        let title: String
        let reversed: Bool
    }

    var identifier: String { "Ordering" }

    let items: [Item]
}

extension OrderingCellViewModel: Equatable {
    static func == (lhs: OrderingCellViewModel, rhs: OrderingCellViewModel) -> Bool {
        lhs.items == rhs.items
    }
}
