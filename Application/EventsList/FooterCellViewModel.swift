//
//  FooterItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

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
