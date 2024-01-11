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
        _ viewModel: EventsListViewModel,
        _ oldValue: EventsListViewModel?
    ) {
        var newSnapshot = makeSnapshot(for: viewModel)

        if let oldValue {
            for newItem in newSnapshot.itemIdentifiers {
                if let oldItem = oldValue.cellAt(identifier: newItem),
                   let newItem = viewModel.cellAt(identifier: newItem),
                   reconfigurationNeeded(oldItem, newItem)
                {
                    newSnapshot.reconfigureItems([newItem.identifier])
                }
            }
        }

        apply(newSnapshot, animatingDifferences: oldValue != nil)
    }

    private func reconfigurationNeeded<T: EventsListItemViewModeling, U: EventsListItemViewModeling>(_ lhs: T, _ rhs: U) -> Bool {
        let cellsHaveSameType = type(of: lhs) == type(of: rhs)
        let cellsHaveSameId = lhs.identifier == rhs.identifier
        let cellsHaveDifferentContent = lhs.self != rhs.self as? T
        let cellMustBeAnimated = {
            if let eventCell = rhs as? EventCellViewModel,
               eventCell.animation != .none
            { return true }
            return false
        }()

        return
            cellsHaveSameType && cellsHaveSameId && cellsHaveDifferentContent ||
            cellMustBeAnimated
    }

    private func makeSnapshot(for vm: EventsListViewModel) -> NSDiffableDataSourceSnapshot<Int, String> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(vm.cellsIdentifiers)
        return snapshot
    }

    func register(_ table: UITableView) {
        table.register(HintCell.self, forCellReuseIdentifier: HintCell.reuseIdentifier)
        table.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
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
        case let viewModel as EventCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: forIndex) as! EventCell
            cell.viewModel = viewModel
            return cell
        case let viewModel as FooterCellViewModel:
            let cell = table.dequeueReusableCell(withIdentifier: FooterCell.reuseIdentifier, for: forIndex) as! FooterCell
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
