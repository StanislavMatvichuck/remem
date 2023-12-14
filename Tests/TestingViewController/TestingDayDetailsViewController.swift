//
//  DayDetailsControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == DayDetailsViewController {
    func make() {
        let day = DayIndex.referenceValue
        event = Event(name: "Event")
        let container = ApplicationContainer(mode: .unitTest)
            .makeContainer()
            .makeContainer(event: event, today: day)
        let weekContainer = WeekContainer(parent: container)
        sut = DayDetailsContainer(
            parent: container,
            day: day,
            hour: 0,
            minute: 0
        ).make() as? DayDetailsViewController
        sut.loadViewIfNeeded()
    }

    var table: UITableView { sut.viewRoot.happenings }
    var firstIndex: IndexPath { IndexPath(row: 0, section: 0) }
    var happeningsAmount: Int { table.numberOfRows(inSection: 0) }

    func happening(at index: IndexPath) -> DayCell {
        do {
            let cell = table.dataSource?.tableView(table, cellForRowAt: index)
            return try XCTUnwrap(cell as? DayCell)
        } catch { fatalError("happening getting error") }
    }

    func addHappening(at date: Date) {
        event.addHappening(date: date)
    }

    func sendEventUpdatesToController() {
        sut.update()
    }
}
