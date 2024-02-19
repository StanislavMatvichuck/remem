//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

protocol EventsListDataProviding {
    var viewModel: EventsListViewModel? { get }
}

struct EventsListDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<EventsListViewModel.Section, String>

    private let provider: EventsListDataProviding
    private let dataSource: DataSource

    init(list: UICollectionView, provider: EventsListDataProviding) {
        let hintCellRegistration = UICollectionView.CellRegistration<HintCell, HintCellViewModel> { cell, _, viewModel in cell.viewModel = viewModel }
        let eventCellRegistration = UICollectionView.CellRegistration<EventCell, EventCellViewModel> { cell, _, viewModel in cell.viewModel = viewModel }
        let createEventCellRegistration = UICollectionView.CellRegistration<CreateEventCell, CreateEventCellViewModel> { cell, _, viewModel in cell.viewModel = viewModel }

        self.provider = provider
        dataSource = DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let item = provider.viewModel?.cell(identifier: itemIdentifier) else { fatalError() }

            switch indexPath.section {
            case EventsListViewModel.Section.hint.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: hintCellRegistration,
                    for: indexPath,
                    item: item as? HintCellViewModel
                )
            case EventsListViewModel.Section.events.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: eventCellRegistration,
                    for: indexPath,
                    item: item as? EventCellViewModel
                )
            case EventsListViewModel.Section.createEvent.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: createEventCellRegistration,
                    for: indexPath,
                    item: item as? CreateEventCellViewModel
                )
            default: fatalError()
            }
        }
    }

    func applySnapshot(_ oldValue: EventsListViewModel?) {
        guard
            let viewModel = provider.viewModel,
            !viewModel.removalDropAreaEnabled
        else { return }
        var snapshot = Snapshot()

        for section in viewModel.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(
                viewModel.cellsIdentifiers(for: section),
                toSection: section
            )
        }

        if let oldValue {
            let reconfiguredIdentifiers = viewModel.cellsRequireReconfigurationIds(oldValue: oldValue)
            snapshot.reconfigureItems(reconfiguredIdentifiers)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
