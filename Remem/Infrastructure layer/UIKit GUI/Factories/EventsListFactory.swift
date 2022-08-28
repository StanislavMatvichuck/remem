//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import UIKit

class EventsListFactory: EventsListFactoryInterface {
    // MARK: - Properties
    let viewModel: EventsListViewModel
    let table: UITableView
    let swipeView: SwipeGestureView
    let view: EventsListView
    let coordinator: Coordinator

    let coordinatorFactory: CoordinatorFactory
    var eventsListUseCase: EventsListUseCase { coordinatorFactory.eventsListUseCase }
    var eventEditUseCase: EventEditUseCase { coordinatorFactory.eventEditUseCase }
    var eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput> { coordinatorFactory.eventsListMulticastDelegate }
    var eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput> { coordinatorFactory.eventEditMulticastDelegate }

    // MARK: - Init
    init(coordinatorFactory: CoordinatorFactory, coordinator: Coordinator) {
        func makeTableView() -> UITableView {
            let table = UITableView(al: true)
            table.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
            table.register(EventsListHintCell.self, forCellReuseIdentifier: EventsListHintCell.reuseIdentifier)
            table.register(EventsListFooterCell.self, forCellReuseIdentifier: EventsListFooterCell.reuseIdentifier)
            table.backgroundColor = .clear
            table.separatorStyle = .none
            return table
        }

        func makeEventsListViewModel() -> EventsListViewModel {
            let viewModel = EventsListViewModel(listUseCase: coordinatorFactory.eventsListUseCase,
                                                editUseCase: coordinatorFactory.eventEditUseCase)
            coordinatorFactory.eventsListMulticastDelegate.addDelegate(viewModel)
            coordinatorFactory.eventEditMulticastDelegate.addDelegate(viewModel)
            viewModel.coordinator = coordinator
            return viewModel
        }

        func makeSwipeView() -> SwipeGestureView {
            SwipeGestureView(mode: .horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)
        }

        func makeInputView() -> UIMovableTextView {
            UIMovableTextView()
        }

        let swipeView = makeSwipeView()
        let table = makeTableView()
        let input = makeInputView()
        let view = EventsListView(input: input, table: table, swipeHint: swipeView)

        self.swipeView = swipeView
        self.table = table
        self.view = view
        self.viewModel = makeEventsListViewModel()
        self.coordinatorFactory = coordinatorFactory
        self.coordinator = coordinator
    }

    func makeEventsListController() -> EventsListController {
        let controller = EventsListController(view: view,
                                              viewModel: viewModel,
                                              factory: self)
        viewModel.delegate = controller
        return controller
    }

    func makeHintCell() -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: EventsListHintCell.reuseIdentifier) as! EventsListHintCell
        cell.label.text = viewModel.hint.text
        return cell
    }

    func makeFooterCell() -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: EventsListFooterCell.reuseIdentifier) as! EventsListFooterCell
        cell.buttonAdd.backgroundColor = viewModel.isAddButtonHighlighted ? .systemBlue : .systemGray
        return cell
    }

    func makeEventCell(for index: IndexPath) -> UITableViewCell {
        guard
            let row = table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let viewModel = makeEventCellViewModel(for: index, row: row)
        else { return UITableViewCell() }
        row.viewModel = viewModel
        configureSwipeHintIfNeeded(index, row)
        return row
    }

    func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration? {
        guard let event = viewModel.event(at: index) else { return nil }

        let renameAction = UIContextualAction(style: .normal, title: EventsListView.rename) { _, _, completion in
            self.viewModel.selectForRenaming(event: event)
            completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: EventsListView.delete) { _, _, completion in
            self.viewModel.selectForRemoving(event: event)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
    }

    private func makeEventCellViewModel(for index: IndexPath, row: EventCell) -> EventCellViewModel? {
        guard let event = viewModel.event(at: index) else { return nil }
        let viewModel = EventCellViewModel(event: event, editUseCase: eventEditUseCase)
        viewModel.delegate = row
        viewModel.coordinator = coordinator
        return viewModel
    }

    private func configureSwipeHintIfNeeded(_ indexPath: IndexPath, _ row: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == EventsListView.Section.events.rawValue,
            viewModel.hint == .placeFirstMark
        else { return }
        row.contentView.addAndConstrain(swipeView)
        swipeView.start()
    }
}
