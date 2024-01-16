//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

//extension TestingViewController where Controller == EventsListViewController {
//    var table: UITableView { sut.viewRoot.table }
//    var eventsCount: Int {
//        let presentSections = sut.viewModel!.sections
//        for (index, presentSection) in presentSections.enumerated() {
//            if presentSection == .events { return table.numberOfRows(inSection: index) }
//        }
//        return 0
//    }
//
//    func make() {
//        sut = EventsListContainer(ApplicationContainer(mode: .unitTest)).make() as? EventsListViewController
//        sut.loadViewIfNeeded()
//    }
//
//    func arrangeSingleEventSwiped() {
//        submitEvent()
//        swipeFirstEvent()
//    }
//
//    func swipeFirstEvent() {
//        if let cell = (sut.viewModel?.cells(for: .events) as? [EventCellViewModel])?.first {
//            cell.swipeHandler()
//        }
//    }
//
//    func submitEvent() {
//        let input = sut.viewRoot.input
//        input.value = "SubmittedEventName"
//
//        _ = input.inputContainer.field.delegate?.textFieldShouldReturn?(
//            input.inputContainer.field
//        )
//    }
//
//    var hintText: String? {
//        if let cell = (sut.viewModel?.cells(for: .hint) as? [HintCellViewModel])?.first {
//            return cell.title
//        }
//
//        return nil
//    }
//
//    var firstEvent: EventCell {
//        let presentSections = sut.viewModel!.sections
//        for (index, presentSection) in presentSections.enumerated() {
//            if presentSection == .events {
//                return table.cellForRow(
//                    at: IndexPath(row: 0, section: index)
//                ) as! EventCell
//            }
//        }
//        fatalError()
//    }
//
//    func submittedEventTrailingSwipeActionButton(number: Int) -> UIContextualAction {
//        submitEvent()
//
//        sut.view.bounds = UIScreen.main.bounds
//        sut.view.layoutIfNeeded()
//
//        let index = IndexPath(row: 1, section: 0)
//
//        guard let config = table.delegate?.tableView?(table, trailingSwipeActionsConfigurationForRowAt: index) else {
//            fatalError("unable to get trailing swiping action for first event")
//        }
//
//        return config.actions[number]
//    }
//
//    func forceViewToLayoutInScreenSize() {
//        sut.view.bounds = UIScreen.main.bounds
//        sut.view.layoutIfNeeded()
//    }
//
//    // MARK: - Specific cases
//    func makeWithVisitedEvent() {
//        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
//        event.visit()
//        let appC = ApplicationContainer(mode: .uikit)
//        appC.commander.save(event)
//        let container = EventsListContainer(appC)
//        sut = container.make() as? EventsListViewController
//    }
//
//    func makeWithManyEvents() {
//        submitEvent()
//        swipeFirstEvent()
//        submitEvent()
//        submitEvent()
//    }
//}
