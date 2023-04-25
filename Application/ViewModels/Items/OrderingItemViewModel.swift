//
//  OrderingItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import Foundation

struct OrderingItemViewModel: EventsListItemViewModeling {
    struct Item: Equatable {
        let title: String
        let reversed: Bool
    }

    var identifier: String { "Ordering" }

    let items: [Item]
}

extension OrderingItemViewModel: Equatable {
    static func == (lhs: OrderingItemViewModel, rhs: OrderingItemViewModel) -> Bool {
        lhs.items == rhs.items
    }
}
