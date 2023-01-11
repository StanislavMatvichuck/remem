//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

extension EventsListViewController {
    func arrangeSingleEventSwiped() {
        submitEvent()
        swipeFirstEvent()
    }

    func swipeFirstEvent() {
        let cell = tableView(viewRoot.table, cellForRowAt: IndexPath(row: 0, section: 1)) as! EventItem
        cell.swiper.sendActions(for: .primaryActionTriggered)
    }

    func submitEvent() {
        viewRoot.input.value = "SubmittedEventName"

        _ = viewRoot.input.textField.delegate?.textFieldShouldReturn?(
            viewRoot.input.textField
        )
    }

    var hintText: String? {
        let hintCell = viewRoot.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! HintItem
        return hintCell.label.text
    }

    var eventsCount: Int { viewRoot.table.numberOfRows(inSection: 1) }

    var firstEvent: EventItem {
        guard let cell = viewRoot.table.dataSource?.tableView(
            viewRoot.table,
            cellForRowAt: IndexPath(row: 0, section: 1)
        ) as? EventItem else { fatalError("unable to get EventItem") }
        return cell
    }

    static func make() -> EventsListViewController {
        let sut = CompositionRoot(testingInMemoryMode: true).makeEventsListViewController()
        sut.loadViewIfNeeded()
        putInViewHierarchy(sut)
        return sut
    }
}
