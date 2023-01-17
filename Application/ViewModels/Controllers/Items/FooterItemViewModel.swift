//
//  FooterItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

protocol FooterItemViewModeFactoring {
    func makeFooterItemViewModel(eventsCount: Int) -> FooterItemViewModel
}

struct FooterItemViewModel {
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
}

protocol FooterItemViewModelResponding {
    func selected(_ viewModel: FooterItemViewModel)
}

extension EventsListViewController: FooterItemViewModelResponding {
    func selected(_: FooterItemViewModel) {
        viewModel.showInput()
    }
}
