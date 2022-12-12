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
    var hint: EventsListHintItem {
        let hintSection = EventsListViewController.Section.hint.rawValue
        let hintIndexPath = IndexPath(row: 0, section: hintSection)
        let cell = cell(atIndexPath: hintIndexPath)

        do {
            return try XCTUnwrap(cell as? EventsListHintItem)
        } catch { fatalError("unable to get hint") }
    }

    var footer: EventsListFooterItem {
        let footerSection = EventsListViewController.Section.footer.rawValue
        let footerIndexPath = IndexPath(row: 0, section: footerSection)
        let cell = cell(atIndexPath: footerIndexPath)

        do {
            return try XCTUnwrap(cell as? EventsListFooterItem)
        } catch { fatalError("unable to get footer") }
    }

    var addButton: UIButton { footer.button }
    var firstEvent: EventsListItem { event(at: 0) }
    var hintText: String? { hint.label.text }
    var eventsCount: Int {
        viewRoot.table.numberOfRows(
            inSection: EventsListViewController.Section.events.rawValue
        )
    }

    func event(at index: Int) -> EventsListItem {
        do {
            let indexPath = IndexPath(
                row: index,
                section: EventsListViewController.Section.events.rawValue
            )
            let cell = cell(atIndexPath: indexPath)
            return try XCTUnwrap(cell as? EventsListItem)
        } catch { fatalError("unable to get EventCell at \(index)") }
    }

    @discardableResult
    func arrangeSingleEventSwiped() -> EventsListItem {
        submitEvent()

        /// this part works badly
//        XCTAssertEqual(firstEvent.valueLabel.text, "0", "precondition")
//        firstEvent.swiper.sendActions(for: .primaryActionTriggered)
//        return firstEvent

        /// this works
        let cell = firstEvent
        XCTAssertEqual(cell.valueLabel.text, "0", "precondition")
        cell.swiper.sendActions(for: .primaryActionTriggered)
        return cell
    }

    func submitEvent() {
        viewRoot.input.value = "SubmittedEventName"

        _ = viewRoot.input.textField.delegate?.textFieldShouldReturn?(
            viewRoot.input.textField
        )
    }

    private func cell(atIndexPath: IndexPath) -> UITableViewCell {
        let table = viewRoot.table
        let dataSource = table.dataSource
        if let cell = dataSource?.tableView(table, cellForRowAt: atIndexPath) {
            return cell
        } else { fatalError("unable to get cell at \(atIndexPath)") }
    }

    static func make(coordinator: Coordinating = DefaultCoordinator()) -> (sut: EventsListViewController, coordinator: Coordinating) {
        let updater = EventsListsUpdater()
        let provider = EventsRepositoryFake()
        let commander = EventsRepositoryDecorator(
            decoratee: provider,
            updater: updater
        )

        let listViewModelFactory = {
            EventsListViewModel(
                events: provider.get(),
                today: DayComponents(date: .now),
                onAdd: { name in
                    commander.save(Event(name: name))
                },
                itemViewModelFactory: { event, today in
                    EventItemViewModel(
                        event: event,
                        today: today,
                        onSelect: { _ in
                            coordinator.show(UIViewController())
                        },
                        coordinator: coordinator,
                        commander: commander
                    )
                }
            )
        }

        commander.viewModelFactory = listViewModelFactory

        let sut = EventsListViewController(
            viewModel: listViewModelFactory()
        )

        sut.loadViewIfNeeded()
        coordinator.show(sut)
        updater.addDelegate(sut)

        return (sut, coordinator)
    }
}

class DecoratedDefaultCoordinator: Coordinating {
    let decoratee: Coordinating
    let callback: () -> Void

    init(_ coordinator: Coordinating, callBack: @escaping () -> Void) {
        self.decoratee = coordinator
        self.callback = callBack
    }

    func show(_ controller: UIViewController) {
        decoratee.show(controller)

        if controller as? EventsListViewController == nil {
            callback()
        }
    }
}
