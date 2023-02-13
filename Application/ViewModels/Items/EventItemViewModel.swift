//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool
    ) -> EventItemViewModel
}

struct EventItemViewModel: EventsListItemViewModeling {    
    var identifier: String { event.id }

    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    private let event: Event
    private let today: DayIndex
    private let coordinator: DefaultCoordinator
    private let commander: EventsCommanding

    let name: String
    let hintEnabled: Bool
    let amount: String
    var renameHandler: EventItemViewModelRenameResponding?

    init(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        coordinator: DefaultCoordinator,
        commander: EventsCommanding
    ) {
        self.event = event
        self.today = today
        self.coordinator = coordinator
        self.commander = commander

        self.name = event.name
        self.hintEnabled = hintEnabled
        self.amount = {
            let todayHappeningsCount = event.happenings(forDayIndex: today).count
            return String(todayHappeningsCount)
        }()
    }

    func select() {
        coordinator.state = .eventDetails(today: today, event: event)
    }

    func swipe() {
        event.addHappening(date: .now)
        commander.save(event)
    }

    func remove() {
        commander.delete(event)
    }

    func initiateRenaming() {
        guard let renameHandler else {
            print("⚠️ EventItemViewModel trying to use renameHandler which is nil")
            return
        }

        renameHandler.renameRequested(self)
    }

    func rename(to newName: String) {
        event.name = newName
        commander.save(event)
    }

    func withRenameHandler(_ handler: EventItemViewModelRenameResponding) -> Self {
        var new = self
        new.renameHandler = handler
        return new
    }

    static func == (lhs: EventItemViewModel, rhs: EventItemViewModel) -> Bool {
        lhs.name == rhs.name &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.amount == rhs.amount
    }
}

protocol EventItemViewModelRenameResponding {
    func renameRequested(_ viewModel: EventItemViewModel)
}
