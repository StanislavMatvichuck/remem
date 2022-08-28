//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import UIKit

class EventsListViewFactory {
    lazy var view = makeEventsListView()
    let viewModel: EventsListViewModel
    let table: UITableView
    let swipeView: SwipeGestureView

    init(viewModel: EventsListViewModel) {
        func makeTableView() -> UITableView {
            let table = UITableView(al: true)
            table.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
            table.register(EventsListHintCell.self, forCellReuseIdentifier: EventsListHintCell.reuseIdentifier)
            table.register(EventsListFooterCell.self, forCellReuseIdentifier: EventsListFooterCell.reuseIdentifier)
            table.backgroundColor = .clear
            table.separatorStyle = .none
            return table
        }

        self.swipeView = SwipeGestureView(mode: .horizontal,
                                          edgeInset: .r2 + UIHelper.spacingListHorizontal)
        self.table = makeTableView()
        self.viewModel = viewModel
    }
}

extension EventsListViewFactory {
    func makeEventsListView() -> EventsListView {
        return EventsListView(viewModel: viewModel,
                              container: self,
                              input: UIMovableTextView(),
                              table: table,
                              swipeHint: swipeView)
    }

    func makeFooterCell() -> EventsListFooterCell {
        let cell = table.dequeueReusableCell(withIdentifier: EventsListFooterCell.reuseIdentifier) as! EventsListFooterCell
        cell.buttonAdd.backgroundColor = viewModel.isAddButtonHighlighted ? .systemBlue : .systemGray
        return cell
    }

    func makeHintCell() -> EventsListHintCell {
        let cell = table.dequeueReusableCell(withIdentifier: EventsListHintCell.reuseIdentifier) as! EventsListHintCell
        cell.label.text = viewModel.hint.text
        return cell
    }

    func makeEventCellFor(_ index: IndexPath) -> UITableViewCell {
        guard
            let row = table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let vm = makeEventCellViewModel(for: index, row: row)
        else { return UITableViewCell() }

        row.viewModel = vm

        configureSwipeHintIfNeeded(index, row)
        return row
    }

    func makeEventCellViewModel(for index: IndexPath, row: EventCell) -> EventCellViewModel? {
        guard let event = viewModel.event(at: index) else { return nil }
        let vm = EventCellViewModel(event: event, delegate: viewModel, view: row)
        vm.view = row
        return vm
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
}

// MARK: - Private
extension EventsListViewFactory {
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
