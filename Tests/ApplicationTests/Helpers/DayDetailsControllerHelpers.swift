//
//  DayDetailsControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

extension DayDetailsViewController {
    var table: UITableView { viewRoot.happenings }
    var firstIndex: IndexPath { IndexPath(row: 0, section: 0) }
    var happeningsAmount: Int { table.numberOfRows(inSection: 0) }

    func happening(at index: IndexPath) -> DayHappeningCell {
        do {
            let cell = table.dataSource?.tableView(table, cellForRowAt: index)
            return try XCTUnwrap(cell as? DayHappeningCell)
        } catch { fatalError("happening getting error") }
    }

    static func make(
        event: Event = Event(name: "Event"),
        day: DayComponents = DayComponents(date: .now)
    ) -> DayDetailsViewController {
        let useCase = EventEditUseCasingFake()
        let sut = DayDetailsViewController(
            day: day,
            event: event,
            useCase: useCase
        )
        sut.loadViewIfNeeded()

        _ = UINavigationController(rootViewController: sut)

        putInViewHierarchy(sut)

        return sut
    }
}
