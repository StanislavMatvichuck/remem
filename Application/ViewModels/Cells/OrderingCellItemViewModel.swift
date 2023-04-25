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
    let reversed: Bool
    private let selectionHandler: SelectionHandler
    private let sorter: EventsQuerySorter

    init(sorter: EventsQuerySorter, handler: @escaping SelectionHandler) {
        self.sorter = sorter
        self.title = sorter.title
        self.reversed = false
        self.selectionHandler = handler
    }

    func select() { selectionHandler(sorter) }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && lhs.reversed == rhs.reversed
    }
}
