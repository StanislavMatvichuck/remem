//
//  FooterItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

protocol FooterItemViewModelTapHandling {
    func tapped(_ vm: FooterCellViewModel)
}

struct FooterCellViewModel: EventsListItemViewModeling {
    static let title = String(localizationId: "button.create")

    var identifier: String { "Footer" }

    let isHighlighted: Bool
    let tapHandler: FooterItemViewModelTapHandling?

    init(eventsCount: Int, tapHandler: FooterItemViewModelTapHandling?) {
        self.isHighlighted = eventsCount == 0
        self.tapHandler = tapHandler
    }

    func select() { tapHandler?.tapped(self) }

    static func == (lhs: FooterCellViewModel, rhs: FooterCellViewModel) -> Bool {
        lhs.isHighlighted == rhs.isHighlighted
    }
}

protocol FooterItemViewModeFactoring {
    func makeFooterItemViewModel(
        eventsCount: Int,
        handler: FooterItemViewModelTapHandling?
    ) -> FooterCellViewModel
}
