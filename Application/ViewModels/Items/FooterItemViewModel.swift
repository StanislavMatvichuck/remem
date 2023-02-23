//
//  FooterItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

struct FooterItemViewModel: EventsListItemViewModeling {
    var identifier: String { "Footer" }

    let title = String(localizationId: "button.create")
    let isHighlighted: Bool
    var selectionHandler: FooterItemViewModelResponding?

    init(eventsCount: Int) {
        isHighlighted = eventsCount == 0
    }

    func select() {
        guard let selectionHandler else {
            print("⚠️ FooterItemViewModel trying to use responder which is nil")
            return
        }

        selectionHandler.selected(self)
    }

    func withSelectionHandler(_ handler: FooterItemViewModelResponding) -> Self {
        var new = self
        new.selectionHandler = handler
        return new
    }

    static func == (lhs: FooterItemViewModel, rhs: FooterItemViewModel) -> Bool {
        lhs.title == rhs.title && lhs.isHighlighted == rhs.isHighlighted
    }
}

protocol FooterItemViewModelResponding {
    func selected(_ viewModel: FooterItemViewModel)
}
