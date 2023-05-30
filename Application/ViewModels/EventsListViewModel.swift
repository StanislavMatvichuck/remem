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

    private let today: DayIndex

    var renamedItem: EventCellViewModel?
    var inputVisible: Bool = false
    var inputContent: String = ""

    var items: [any EventsListItemViewModeling]

    let addHandler: AddEventHandler

    init(
        today: DayIndex,
        items: [any EventsListItemViewModeling],
        addHandler: @escaping AddEventHandler
    ) {
        self.today = today
        self.items = items
        self.addHandler = addHandler
    }

    mutating func showInput() {
        inputVisible = true
    }

    subscript(identifier: String) -> Int? {
        for (index, item) in items.enumerated() {
            if item.hasSame(identifier: identifier) {
                return index
            }
        }
        return nil
    }
}
