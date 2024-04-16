//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

protocol ShowEventDetailsServiceFactoring { func makeShowEventDetailsService(id: String) -> ShowEventDetailsService }
protocol RemoveEventServiceFactoring { func makeRemoveEventService(id: String) -> RemoveEventService }
protocol CreateHappeningServiceFactoring { func makeCreateHappeningService(id: String) -> CreateHappeningService }

struct EventsListDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<EventsListViewModel.Section, String>

    private let dataSource: DataSource
    private let viewModelProvider: EventsListViewModelFactoring
    private let showEventDetailsService: ShowEventDetailsServiceFactoring
    private let createHappeningService: CreateHappeningServiceFactoring
    private let removeEventService: RemoveEventServiceFactoring
    private let showCreateEventService: ShowCreateEventService

    init(
        list: UICollectionView,
        viewModelProvider: EventsListViewModelFactoring,
        showEventDetailsService: ShowEventDetailsServiceFactoring,
        createHappeningService: CreateHappeningServiceFactoring,
        removeEventService: RemoveEventServiceFactoring,
        showCreateEventService: ShowCreateEventService
    ) {
        self.viewModelProvider = viewModelProvider
        self.showEventDetailsService = showEventDetailsService
        self.createHappeningService = createHappeningService
        self.removeEventService = removeEventService
        self.showCreateEventService = showCreateEventService

        let hintCellRegistration = UICollectionView.CellRegistration<HintCell, HintCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
        }
        let eventCellRegistration = UICollectionView.CellRegistration<EventCell, EventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = showEventDetailsService.makeShowEventDetailsService(id: viewModel.id)
            cell.swipeService = createHappeningService.makeCreateHappeningService(id: viewModel.id)
            cell.removeService = removeEventService.makeRemoveEventService(id: viewModel.id)
        }
        let createEventCellRegistration = UICollectionView.CellRegistration<CreateEventCell, CreateEventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = showCreateEventService
        }

        dataSource = DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let cellViewModel = viewModelProvider.makeEventsListViewModel().viewModel(forIdentifier: itemIdentifier) else { fatalError() }

            switch indexPath.section {
            case EventsListViewModel.Section.hint.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: hintCellRegistration,
                    for: indexPath,
                    item: cellViewModel as? HintCellViewModel
                )
            case EventsListViewModel.Section.events.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: eventCellRegistration,
                    for: indexPath,
                    item: cellViewModel as? EventCellViewModel
                )
            case EventsListViewModel.Section.createEvent.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: createEventCellRegistration,
                    for: indexPath,
                    item: cellViewModel as? CreateEventCellViewModel
                )
            default: fatalError()
            }
        }
    }

    func applySnapshot(_ oldValue: EventsListViewModel?) {
        let viewModel = viewModelProvider.makeEventsListViewModel()
        guard viewModel.removalDropAreaHidden else { return }

        var snapshot = Snapshot()

        for section in EventsListViewModel.sections {
            let identifiers = viewModel.identifiersFor(section: section)
            snapshot.appendSections([section])
            snapshot.appendItems(identifiers, toSection: section)
            // TODO: optimize this solution
            snapshot.reconfigureItems(identifiers)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
