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

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventItemViewModel
}

struct EventItemViewModel: EventsListItemViewModeling {
    typealias TapHandler = () -> Void
    typealias SwipeHandler = () -> Void
    typealias RenameActionHandler = (EventItemViewModel) -> Void
    typealias DeleteActionHandler = () -> Void
    typealias RenameHandler = (String, Event) -> Void

    var identifier: String { event.id }

    private let event: Event
    private let valueAmount: Int

    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    let title: String
    let hintEnabled: Bool
    let value: String
    let tapHandler: TapHandler
    let swipeHandler: SwipeHandler
    let renameActionHandler: RenameActionHandler
    let deleteActionHandler: DeleteActionHandler
    let renameHandler: RenameHandler

    init(
        event: Event,
        hintEnabled: Bool,
        today: DayIndex,
        tapHandler: @escaping TapHandler,
        swipeHandler: @escaping SwipeHandler,
        renameActionHandler: @escaping RenameActionHandler,
        deleteActionHandler: @escaping DeleteActionHandler,
        renameHandler: @escaping RenameHandler
    ) {
        self.event = event
        self.title = event.name
        self.hintEnabled = hintEnabled
        self.valueAmount = event.happenings(forDayIndex: today).count
        self.value = "\(valueAmount)"
        self.tapHandler = tapHandler
        self.swipeHandler = swipeHandler
        self.renameActionHandler = renameActionHandler
        self.deleteActionHandler = deleteActionHandler
        self.renameHandler = renameHandler
    }

    func isValueIncreased(_ oldValue: EventItemViewModel) -> Bool {
        valueAmount > oldValue.valueAmount
    }

    func rename(to: String) { renameHandler(to, event) }

    static func == (lhs: EventItemViewModel, rhs: EventItemViewModel) -> Bool {
        lhs.title == rhs.title &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.value == rhs.value
    }
}
