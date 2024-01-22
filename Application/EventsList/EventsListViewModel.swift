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

    typealias SortingTapHandler = (CGFloat, Bool) -> Void
    typealias ManualSortingHandler = ([String]) -> Void

    private var cells: [Section: [AnyHashable]]
    private let sorter: EventsSorter
    let eventsSortingHandler: SortingTapHandler?
    let manualSortingHandler: ManualSortingHandler?

    init(
        cells: [Section: [AnyHashable]],
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

    func cells(for section: Section) -> [AnyHashable] { cells[section] ?? [] }

    mutating func configureAnimationForEventCells(_ oldViewModel: EventsListViewModel?) {
        guard let oldViewModel else { return }
        for (index, oldCell) in oldViewModel.eventCells.enumerated() {
            guard
                let newCell = (cells[.events] as? [EventCellViewModel])?[index],
                newCell.identifier == oldCell.identifier,
                newCell.isValueIncreased(oldCell)
            else { continue }
            configure(animation: .swipe, for: newCell)

            if let previousCell = eventCellRelative(to: newCell, offset: -1) {
                configure(animation: .aboveSwipe, for: previousCell)
            }

            if let nextEventId = eventCellRelative(to: newCell, offset: 1) {
                configure(animation: .belowSwipe, for: nextEventId)
            }
        }
    }

    func shouldPresentManualSorting(_ oldValue: EventsListViewModel? = nil) -> Bool {
        guard let oldValue else { return false }
        return sorter == .manual && oldValue.sorter != .manual
    }

    func eventCellRelative(to cell: EventCellViewModel, offset: Int) -> EventCellViewModel? {
        guard let eventsCells = cells[.events] else { return nil }

        for (index, iterationCell) in eventCells.enumerated() {
            let modifiedIndex = index + offset

            guard
                iterationCell.identifier == cell.identifier,
                modifiedIndex >= 0,
                modifiedIndex < eventsCells.count,
                let result = eventsCells[modifiedIndex] as? EventCellViewModel
            else { continue }
            return result
        }

        return nil
    }

    // MARK: - Private
    private mutating func configure(animation: EventCellViewModel.Animations, for cell: EventCellViewModel) {
        for (index, iterationCell) in eventCells.enumerated() {
            guard
                iterationCell.identifier == cell.identifier
            else { continue }
            cells[.events]![index] = iterationCell.clone(withAnimation: animation)
        }
    }

    private var eventCells: [EventCellViewModel] { cells[.events] as! [EventCellViewModel] }
}
