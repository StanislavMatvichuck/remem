//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

protocol EventItemViewModelRenameHandling {
    func renameTapped(_: EventItemViewModel)
}

struct EventItemViewModel: EventsListItemViewModeling {
    var identifier: String { event.id }

    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    private let event: Event
    private let today: DayIndex
    private let commander: EventsCommanding

    let name: String
    let hintEnabled: Bool
    let amount: String

    let renameHandler: EventItemViewModelRenameHandling?
    let tapHandler: () -> ()

    init(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        commander: EventsCommanding,
        renameHandler: EventItemViewModelRenameHandling?,
        tapHandler: @escaping () -> ()
    ) {
        self.event = event
        self.today = today
        self.commander = commander
        self.tapHandler = tapHandler
        self.renameHandler = renameHandler

        self.name = event.name
        self.hintEnabled = hintEnabled
        self.amount = {
            let todayHappeningsCount = event.happenings(forDayIndex: today).count
            return String(todayHappeningsCount)
        }()
    }

    func select() { tapHandler() }

    func swipe() {
        event.addHappening(date: .now)
        commander.save(event)
    }

    func remove() {
        commander.delete(event)
    }

    func initiateRenaming() { renameHandler?.renameTapped(self) }

    func rename(to newName: String) {
        event.name = newName
        commander.save(event)
    }

    static func == (lhs: EventItemViewModel, rhs: EventItemViewModel) -> Bool {
        lhs.name == rhs.name &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.amount == rhs.amount
    }
}

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventItemViewModel
}
