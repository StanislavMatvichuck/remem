//
//  DayDetailsControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

extension DayViewController {
    var table: UITableView { viewRoot.happenings }
    var firstIndex: IndexPath { IndexPath(row: 0, section: 0) }
    var happeningsAmount: Int { table.numberOfRows(inSection: 0) }

    func happening(at index: IndexPath) -> DayItem {
        do {
            let cell = table.dataSource?.tableView(table, cellForRowAt: index)
            return try XCTUnwrap(cell as? DayItem)
        } catch { fatalError("happening getting error") }
    }

    static func make(
        event: Event = Event(name: "Event"),
        day: DayComponents = DayComponents(date: .now)
    ) -> DayViewController {
        let sut = CompositionRoot(testingInMemoryMode: true).makeDayViewController(event, day)

        sut.loadViewIfNeeded()

        putInViewHierarchy(sut)

        return sut
    }
}
