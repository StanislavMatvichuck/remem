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

protocol FooterItemViewModelResponding {
    func selected()
}

struct FooterItemViewModel: EventsListItemViewModel {
    let title = String(localizationId: "button.create")
    let isHighlighted: Bool
    var responder: FooterItemViewModelResponding?

    init(eventsCount: Int) {
        isHighlighted = eventsCount == 0
    }

    mutating func select() {
        responder?.selected()
    }
}

extension EventsListViewModel {
    mutating func setResponderForFooterItemViewModel(
        _ footerHandler: FooterItemViewModelResponding
    ) {
        for (sectionIndex, section) in sections.enumerated() {
            for (itemIndex, item) in section.enumerated() {
                if var updatedFooterItem = item as? FooterItemViewModel {
                    updatedFooterItem.responder = footerHandler
                    sections[sectionIndex][itemIndex] = updatedFooterItem
                }
            }
        }
    }
}

extension EventsListViewController: FooterItemViewModelResponding {
    func selected() {
        viewModel.showInput()
    }
}
