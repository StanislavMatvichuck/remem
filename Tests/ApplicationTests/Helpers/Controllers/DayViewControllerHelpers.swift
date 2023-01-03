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
}

protocol DayViewControllerTesting {
    var sut: DayViewController! { get set }
    var event: Event! { get set }
}

extension DayViewControllerTesting {
    func addHappening(at date: Date) {
        event.addHappening(date: date)
    }

    func sendEventUpdatesToController() {
        sut.viewModel = sut.viewModel.copy(newEvent: event)
    }
}
