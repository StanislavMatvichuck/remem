//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

struct WidgetViewModelFactoringStub: WidgetViewModelFactoring {
    func makeWidgetViewModel() -> WidgetViewModel { [] }
}

extension TestingViewController where Controller == EventsListViewController {
    func make() {
        sut = ApplicationContainer.make()
        sut.loadViewIfNeeded()
    }

    func arrangeSingleEventSwiped() {
        submitEvent()
        swipeFirstEvent()
    }

    func swipeFirstEvent() {
        guard let cell = sut.viewRoot.table.dataSource?.tableView(sut.viewRoot.table, cellForRowAt: IndexPath(row: 1, section: 0)) as? EventItem else { return }
        cell.swiper.sendActions(for: .primaryActionTriggered)
    }

    func submitEvent() {
        sut.viewRoot.input.value = "SubmittedEventName"

        _ = sut.viewRoot.input.textField.delegate?.textFieldShouldReturn?(
            sut.viewRoot.input.textField
        )
    }

    var hintText: String? {
        let hintCell = sut.viewRoot.table.cellForRow(at: IndexPath(row: 0, section: 0)) as! HintItem
        return hintCell.label.text
    }

    var eventsCount: Int {
        sut.viewRoot.table.numberOfRows(inSection: 0) - 2
    }

    var firstEvent: EventItem {
        guard let cell = sut.viewRoot.table.dataSource?.tableView(
            sut.viewRoot.table,
            cellForRowAt: IndexPath(row: 1, section: 0)
        ) as? EventItem else { fatalError("unable to get EventItem") }
        return cell
    }

    var footer: FooterItem {
        guard let cell = sut.viewRoot.table.dataSource?.tableView(
            sut.viewRoot.table,
            cellForRowAt: IndexPath(row: 0, section: 2)
        ) as? FooterItem else { fatalError("unable to get footer") }
        return cell
    }

    func submittedEventTrailingSwipeActionButton(number: Int) -> UIContextualAction {
        submitEvent()

        let table = sut.viewRoot.table
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

    func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}
