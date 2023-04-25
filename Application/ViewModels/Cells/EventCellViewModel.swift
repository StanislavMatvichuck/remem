//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

protocol EventItemViewModelRenameHandling {
    func renameTapped(_: EventCellViewModel)
}

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventCellViewModel
}

struct EventCellViewModel: EventsListItemViewModeling {
    typealias TapHandler = () -> Void
    typealias SwipeHandler = () -> Void
    typealias RenameActionHandler = (EventCellViewModel) -> Void
    typealias DeleteActionHandler = () -> Void
    typealias RenameHandler = (String, Event) -> Void

    var identifier: String { event.id }

    private let event: Event
    private let valueAmount: Int

    let rename = String(localizationId: "button.rename")
    let delete = String(localizationId: "button.delete")

    let title: String
    let value: String
    let timeSince: String
    let hintEnabled: Bool
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
        self.valueAmount = event.happenings(forDayIndex: today).count
        self.event = event

        self.title = event.name
        self.value = "\(valueAmount)"
        self.timeSince = {
            if let happening = event.happenings.last {
                return Self.timeSinceDate(date: happening.dateCreated, now: .now)
            } else {
                return String(localizationId: "eventsList.timeSince")
            }
        }()
        self.hintEnabled = hintEnabled

        self.tapHandler = tapHandler
        self.swipeHandler = swipeHandler
        self.renameActionHandler = renameActionHandler
        self.deleteActionHandler = deleteActionHandler
        self.renameHandler = renameHandler
    }

    func isValueIncreased(_ oldValue: EventCellViewModel) -> Bool {
        valueAmount > oldValue.valueAmount
    }

    func rename(to: String) { renameHandler(to, event) }

    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        lhs.title == rhs.title &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.value == rhs.value &&
            lhs.timeSince == rhs.timeSince
    }

    static func timeSinceDate(date: Date, now: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        return formatter.string(from: date, to: now) ?? ""
    }
}
