//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

final class EventsListDataSource: UITableViewDiffableDataSource<Int, String> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        tableView.dequeueReusableCell(withIdentifier: EventItem.reuseIdentifier, for: indexPath) is EventItem
    }

    func update(
        _ items: [any EventsListItemViewModeling],
        _ oldValue: EventsListViewModel?
    ) {
        var newSnapshot = makeSnapshot(items: items)

        if let oldValue {
            for newItem in newSnapshot.itemIdentifiers {
                if let oldItem = oldValue.items.first(where: { $0.identifier == newItem }),
                   let newItem = items.first(where: { $0.identifier == newItem }),
                   reconfigurationNeeded(oldItem, newItem)
                {
                    newSnapshot.reconfigureItems([newItem.identifier])
                }
            }
        }

        apply(newSnapshot, animatingDifferences: oldValue != nil)
    }

    private func reconfigurationNeeded<
        T: EventsListItemViewModeling,
        U: EventsListItemViewModeling
    >(_ lhs: T, _ rhs: U) -> Bool {
        type(of: lhs) == type(of: rhs) &&
            lhs.identifier == rhs.identifier &&
            lhs.self != rhs.self as? T
    }

    private func makeSnapshot(items: [any EventsListItemViewModeling]) -> NSDiffableDataSourceSnapshot<Int, String> {
        let itemsIDs = items.map { $0.identifier }

        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(itemsIDs)
        return snapshot
    }
}

protocol EventsListCell: UITableViewCell {
    associatedtype ViewModel: EventsListItemViewModeling
    var viewModel: ViewModel? { get set }
    static var reuseIdentifier: String { get }
}

protocol TrailingSwipeActionsConfigurationProviding {
    func trailingActionsConfiguration() -> UISwipeActionsConfiguration
}

// TODO: Get rid of casting, rely on runtime, or event on compiler if possible
enum EventsListCellProvider {
    static func cell(
        table: UITableView,
        forIndex: IndexPath,
        viewModel: any EventsListItemViewModeling
    ) -> UITableViewCell {
        switch viewModel {
        case let viewModel as HintItemViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: HintItem.reuseIdentifier, for: forIndex) as! HintItem
            cell.viewModel = viewModel
            return cell
        case let viewModel as FooterItemViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: FooterItem.reuseIdentifier, for: forIndex) as! FooterItem
            cell.viewModel = viewModel
            return cell
        case let viewModel as EventItemViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: EventItem.reuseIdentifier, for: forIndex) as! EventItem
            cell.viewModel = viewModel
            return cell
        default: fatalError("unknown cell type")
        }
    }

    static func register(_ table: UITableView) {
        table.register(EventItem.self, forCellReuseIdentifier: EventItem.reuseIdentifier)
        table.register(HintItem.self, forCellReuseIdentifier: HintItem.reuseIdentifier)
        table.register(FooterItem.self, forCellReuseIdentifier: FooterItem.reuseIdentifier)
    }
}
