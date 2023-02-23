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
        guard let cell = viewRoot.table.dataSource?.tableView(viewRoot.table, cellForRowAt: IndexPath(row: 1, section: 0)) as? EventItem else { return }
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

    var eventsCount: Int {
        viewRoot.table.numberOfRows(inSection: 0) - 2
    }

    var firstEvent: EventItem {
        guard let cell = viewRoot.table.dataSource?.tableView(
            viewRoot.table,
            cellForRowAt: IndexPath(row: 1, section: 0)
        ) as? EventItem else { fatalError("unable to get EventItem") }
        return cell
    }

    var footer: FooterItem {
        guard let cell = viewRoot.table.dataSource?.tableView(
            viewRoot.table,
            cellForRowAt: IndexPath(row: 0, section: 2)
        ) as? FooterItem else { fatalError("unable to get footer") }
        return cell
    }

    func submittedEventTrailingSwipeActionButton(number: Int) -> UIContextualAction {
        submitEvent()

        let table = viewRoot.table
        let index = IndexPath(
            row: 1,
            section: 0
        )

        guard let config = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: index
        ) else {
            fatalError("unable to get trailing swiping action for first event")
        }

        return config.actions[number]
    }
}

protocol EventsListViewControllerTesting: AnyObject {
    var sut: EventsListViewController! { get set }
    var commander: EventsCommanding! { get set }
}

extension EventsListViewControllerTesting {
    func makeSutWithViewModelFactory() {
        let container = ApplicationContainer(testingInMemoryMode: true).makeContainer()
        sut = container.makeController()
        commander = container.updater
    }

    func clearSutAndViewModelFactory() {
        sut = nil
        commander = nil
    }

    func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}
