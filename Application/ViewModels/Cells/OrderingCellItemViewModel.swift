//
//  OrderingCellViewModelItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import Domain
import Foundation

struct OrderingCellItemViewModel: Equatable {
    typealias SelectionHandler = (EventsQuerySorter) -> Void

    let title: String
    private let selectionHandler: SelectionHandler
    private let sorter: EventsQuerySorter

    init(sorter: EventsQuerySorter, handler: @escaping SelectionHandler) {
        self.sorter = sorter
        self.title = sorter.title
        self.selectionHandler = handler
    }

    func select() { selectionHandler(sorter) }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
    }

    func hasSame(sorter: EventsQuerySorter) -> Bool {
        return self.sorter == sorter
    }
}
