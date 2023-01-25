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

protocol DayViewControllerTesting: AnyObject {
    var sut: DayViewController! { get set }
    var viewModelFactory: DayViewModelFactoring! { get set }
    var event: Event! { get set }
}

extension DayViewControllerTesting {
    func addHappening(at date: Date) {
        event.addHappening(date: date)
    }

    func sendEventUpdatesToController() {
        sut.viewModel = viewModelFactory.makeViewModel()
    }

    func makeSutWithViewModelFactory() {
        let day = DayComponents.referenceValue
        event = Event(name: "Event")
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: day)
            .makeContainer(day: day)
        sut = container.makeController()
        viewModelFactory = container
    }
}
