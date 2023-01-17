//
//  EventsListItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.01.2023.
//

import Foundation

protocol EventsListItemViewModel {
    func add(_ handler: AnyObject) -> Self
}

extension FooterItemViewModel: EventsListItemViewModel {
    func add(_ handler: AnyObject) -> FooterItemViewModel {
        var newViewModel = self

        if let handler = handler as? FooterItemViewModelResponding {
            newViewModel.selectionHandler = handler
        }

        return newViewModel
    }
}

extension EventItemViewModel: EventsListItemViewModel {
    func add(_ handler: AnyObject) -> EventItemViewModel {
        var newViewModel = self

        if let renameHandler = handler as? EventItemViewModelRenameResponding {
            newViewModel.renameHandler = renameHandler
        }

        return newViewModel
    }
}

extension HintItemViewModel: EventsListItemViewModel {
    func add(_ handler: AnyObject) -> HintItemViewModel {
        return self
    }
}
