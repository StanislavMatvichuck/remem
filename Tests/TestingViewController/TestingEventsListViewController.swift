//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == EventsListViewController {
    var table: UITableView { sut.viewRoot.table }
    var eventsCount: Int { table.numberOfRows(inSection: 0) - 2 }

    func make() {
        sut = ApplicationContainer.make()
        sut.loadViewIfNeeded()
    }

    func arrangeSingleEventSwiped() {
        submitEvent()
        swipeFirstEvent()
    }

    func swipeFirstEvent() {
        if let cell = cell(1) as? EventItem {
            cell.swiper.sendActions(for: .primaryActionTriggered)
        }
    }

    func submitEvent() {
        let input = sut.viewRoot.input
        input.value = "SubmittedEventName"

        _ = input.textField.delegate?.textFieldShouldReturn?(
            input.textField
        )
    }

    func cell(_ forInt: Int) -> UITableViewCell {
        let index = IndexPath(row: forInt, section: 0)
        return table.dataSource!.tableView(table, cellForRowAt: index)
    }

    var hintText: String? {
        if let hintCell = cell(0) as? HintItem {
            return hintCell.label.text
        }

        return nil
    }

    var firstEvent: EventItem {
        if let cell = cell(1) as? EventItem { return cell } else {
            fatalError("unable to get EventItem")
        }
    }

    func submittedEventTrailingSwipeActionButton(number: Int) -> UIContextualAction {
        submitEvent()

        let index = IndexPath(row: 1, section: 0)

        guard let config = table.delegate?.tableView?(table, trailingSwipeActionsConfigurationForRowAt: index) else {
            fatalError("unable to get trailing swiping action for first event")
        }

        return config.actions[number]
    }

    func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}
