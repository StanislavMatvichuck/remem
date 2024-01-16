//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

final class EventsListDataSource: UITableViewDiffableDataSource<EventsListViewModel.Section, AnyHashable> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, AnyHashable>

    let table: UITableView

    var viewModel: EventsListViewModel? {
        didSet {
            guard var viewModel else { return }
            viewModel.configureAnimationForEventCells(oldValue)
            apply(makeSnapshot(for: viewModel), animatingDifferences: true)
        }
    }

    init(table: UITableView) {
        self.table = table
        super.init(tableView: table, cellProvider: Self.Provider)
        defaultRowAnimation = .none

        for sectionType in EventsListViewModel.Section.allCases {
            table.register(sectionType.registeredClass, forCellReuseIdentifier: sectionType.reuseIdentifier)
        }
    }

    private func makeSnapshot(for vm: EventsListViewModel) -> Snapshot {
        var snapshot = Snapshot()

        snapshot.appendSections(vm.sections)

        for section in vm.sections {
            snapshot.appendItems(
                vm.cells(for: section),
                toSection: section
            )
        }

        return snapshot
    }

    static let Provider: UITableViewDiffableDataSourceReferenceCellProvider = {
        table, indexPath, cellViewModel in
        switch cellViewModel {
        case let cellViewModel as HintCellViewModel:
            let cell = table.dequeueReusableCell(
                withIdentifier: HintCell.reuseIdentifier,
                for: indexPath
            ) as! HintCell
            cell.viewModel = cellViewModel
            return cell
        case let cellViewModel as EventCellViewModel:
            let cell = table.dequeueReusableCell(
                withIdentifier: EventCell.reuseIdentifier,
                for: indexPath
            ) as! EventCell
            cell.viewModel = cellViewModel
            return cell
        case let cellViewModel as FooterCellViewModel:
            let cell = table.dequeueReusableCell(
                withIdentifier: FooterCell.reuseIdentifier,
                for: indexPath
            ) as! FooterCell
            cell.viewModel = cellViewModel
            return cell
        default: fatalError("unknown cell type")
        }
    }
}

extension EventsListViewModel.Section {
    var registeredClass: AnyClass? { switch self {
    case .hint: HintCell.self
    case .events: EventCell.self
    case .createEvent: FooterCell.self
    } }

    var reuseIdentifier: String { switch self {
    case .hint: HintCell.reuseIdentifier
    case .events: EventCell.reuseIdentifier
    case .createEvent: FooterCell.reuseIdentifier
    } }
}
