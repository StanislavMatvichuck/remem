//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

final class EventsListDataSource: UITableViewDiffableDataSource<Int, String> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let identifier = itemIdentifier(for: indexPath)
        return identifier != "Hint" &&
            identifier != "Footer" &&
            identifier != "Ordering"
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

    private func reconfigurationNeeded<T: EventsListItemViewModeling, U: EventsListItemViewModeling>(_ lhs: T, _ rhs: U) -> Bool {
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

    func register(_ table: UITableView) {
        table.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        table.register(HintCell.self, forCellReuseIdentifier: HintCell.reuseIdentifier)
        table.register(OrderingCell.self, forCellReuseIdentifier: OrderingCell.reuseIdentifier)
        table.register(FooterCell.self, forCellReuseIdentifier: FooterCell.reuseIdentifier)
    }

    static func cell(
        table: UITableView,
        forIndex: IndexPath,
        viewModel: any EventsListItemViewModeling
    ) -> UITableViewCell {
        switch viewModel {
        case let viewModel as HintCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: HintCell.reuseIdentifier, for: forIndex) as! HintCell
            cell.viewModel = viewModel
            return cell
        case let viewModel as OrderingCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: OrderingCell.reuseIdentifier, for: forIndex) as! OrderingCell
            cell.viewModel = viewModel
            return cell
        case let viewModel as FooterCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: FooterCell.reuseIdentifier, for: forIndex) as! FooterCell
            cell.viewModel = viewModel
            return cell
        case let viewModel as EventCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: forIndex) as! EventCell
            cell.viewModel = viewModel
            return cell
        default: fatalError("unknown cell type")
        }
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
