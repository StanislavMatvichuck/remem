//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain
import Foundation

struct EventsListViewModel {
    enum Section: Int, CaseIterable { case hint, events, createEvent }

    static let title = String(localizationId: "eventsList.title")
    static let eventsSortingLabel = String(localizationId: "eventsSorting.title")

    typealias SortingTapHandler = (CGFloat, EventsSorter?) -> Void
    typealias ManualSortingHandler = ([String]) -> Void

    private var cells: [Section: [any EventsListCellViewModel]]
    let sorter: EventsSorter
    let eventsSortingHandler: SortingTapHandler?
    let manualSortingHandler: ManualSortingHandler?
    var removalDropAreaEnabled = false
    var draggedCell: EventCellViewModel?
    private var fingerPosition: CGFloat = 0.0
    private var fingerPositionMax: CGFloat = 0.0

    init(
        cells: [Section: [any EventsListCellViewModel]],
        sorter: EventsSorter,
        eventsSortingHandler: SortingTapHandler? = nil,
        manualSortingHandler: ManualSortingHandler? = nil
    ) {
        self.cells = cells
        self.sorter = sorter
        self.eventsSortingHandler = eventsSortingHandler
        self.manualSortingHandler = manualSortingHandler
    }

    var sections: [Section] {
        var result: [Section] = []
        for section in Section.allCases {
            if cells[section] != nil { result.append(section) }
        }
        return result
    }

    func cellsIdentifiers(for section: Section) -> [String] {
        cells[section]?.map { $0.id } ?? []
    }

    func cell(identifier: String) -> (any EventsListCellViewModel)? {
        for section in sections {
            if let cells = cells[section] {
                for cell in cells {
                    if cell.id == identifier { return cell }
                }
            }
        }
        return nil
    }

    var isRemovingEnabled: Bool { fingerPosition <= fingerPositionMax / 3 }

    mutating func configureAnimationForEventCells(oldValue: EventsListViewModel?) {
        guard let oldValue else { return }
        var swipedCell: EventCellViewModel?

        var configuredEvents = eventCells.map { cell in
            for oldCell in oldValue.eventCells {
                if cell.id == oldCell.id, cell.isValueIncreased(oldCell) {
                    var updatedCell = cell
                    updatedCell.animation = .swipe
                    swipedCell = updatedCell
                    return updatedCell
                }
            }
            return cell
        }

        if let swipedCell, let index = configuredEvents.firstIndex(of: swipedCell) {
            let previousIndex = configuredEvents.index(before: index)
            if previousIndex >= 0 {
                var previousCell = configuredEvents[previousIndex]
                previousCell.animation = .aboveSwipe
                configuredEvents[previousIndex] = previousCell
            }

            let nextIndex = configuredEvents.index(after: index)
            if nextIndex < configuredEvents.count {
                var nextCell = configuredEvents[nextIndex]
                nextCell.animation = .belowSwipe
                configuredEvents[nextIndex] = nextCell
            }
        }

        cells[.events] = configuredEvents
    }

    func cellsRequireReconfigurationIds(oldValue: EventsListViewModel?) -> [String] {
        guard let oldValue else { return [] }
        var identifiers = [String]()

        for section in sections {
            for cell in cells[section]! {
                for oldCell in oldValue.cells[section]! {
                    if cell.requiresUpdate(oldValue: oldCell) {
                        identifiers.append(cell.id)
                    }
                }
            }
        }

        return identifiers
    }

    func shouldPresentManualSorting(_ oldValue: EventsListViewModel? = nil) -> Bool {
        guard let oldValue else { return false }
        return sorter == .manual && oldValue.sorter != .manual
    }

    mutating func startDragFor(eventIndex: Int) {
        draggedCell = eventCells[eventIndex]
        removalDropAreaEnabled = true
    }

    mutating func disableRemoval() {
        if isRemovingEnabled, let draggedCell {
            draggedCell.remove()
            return
        }

        removalDropAreaEnabled = false
    }

    mutating func updateFinger(position: CGFloat, maxPosition: CGFloat) {
        fingerPosition = position
        fingerPositionMax = maxPosition
    }

    // MARK: - Private
    private var eventCells: [EventCellViewModel] { cells[.events] as! [EventCellViewModel] }
}

private func equals(_ lhs: Any, _ rhs: Any) -> Bool {
    func open<A: Equatable>(_ lhs: A, _ rhs: Any) -> Bool {
        lhs == (rhs as? A)
    }

    guard let lhs = lhs as? any Equatable else { return false }

    return open(lhs, rhs)
}
