//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain

protocol EventsListItemViewModeling: Equatable {
    var identifier: String { get }
}

extension EventsListItemViewModeling {
    func hasSame(identifier: String) -> Bool {
        self.identifier == identifier
    }
}

struct EventsListViewModel {
    static let title = String(localizationId: "eventsList.title")

    typealias AddEventHandler = (String) -> Void

    var renamedItem: EventCellViewModel?
    var inputVisible: Bool = false
    var inputContent: String = ""

    private var cells: [any EventsListItemViewModeling]

    let addHandler: AddEventHandler

    init(
        items: [any EventsListItemViewModeling],
        addHandler: @escaping AddEventHandler
    ) {
        self.cells = items
        self.addHandler = addHandler
    }

    mutating func showInput() {
        inputVisible = true
    }

    var cellsIdentifiers: [String] { cells.map { $0.identifier } }

    func cellAt(identifier: String) -> (any EventsListItemViewModeling)? {
        cells.first(where: { $0.identifier == identifier })
    }

    var eventCells: [EventCellViewModel] {
        cells.filter { type(of: $0) is EventCellViewModel.Type } as! [EventCellViewModel]
    }

    func configureAnimationForEventCells(_ oldValue: EventsListViewModel) -> EventsListViewModel {
        var configured = self

        for oldEvent in oldValue.eventCells {
            guard
                let newEventCell = cellAt(identifier: oldEvent.identifier),
                let newEvent = newEventCell as? EventCellViewModel,
                newEvent.isValueIncreased(oldEvent)
            else { continue }
            configured.configure(animation: .swipe, for: newEvent.identifier)

            if let previousEventId = eventCellIdPrevious(to: newEvent.identifier) {
                configured.configure(animation: .aboveSwipe, for: previousEventId)
            }

            if let nextEventId = eventCellIdNext(to: newEvent.identifier) {
                configured.configure(animation: .belowSwipe, for: nextEventId)
            }
        }

        return configured
    }

    func eventCellIdPrevious(to cellId: String) -> String? {
        for (index, cell) in cells.enumerated() {
            guard
                cell.identifier == cellId,
                let previousCell = cells[index - 1] as? EventCellViewModel
            else { continue }
            return previousCell.identifier
        }

        return nil
    }

    func eventCellIdNext(to cellId: String) -> String? {
        for (index, cell) in cells.enumerated() {
            guard
                cell.identifier == cellId,
                let previousCell = cells[index + 1] as? EventCellViewModel
            else { continue }
            return previousCell.identifier
        }

        return nil
    }

    func isEventAt(index: Int) -> Bool { cells[index] as? EventCellViewModel != nil }

    private mutating func configure(animation: EventCellViewModel.Animations, for cellId: String) {
        for (index, cell) in cells.enumerated() {
            guard
                cell.identifier == cellId,
                let eventCell = cell as? EventCellViewModel
            else { continue }
            cells[index] = eventCell.clone(withAnimation: animation)
        }
    }
}
