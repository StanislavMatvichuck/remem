//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

struct EventsListDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<EventsListViewModel.Section, String>

    private let dataSource: DataSource
    private let viewModelProvider: EventsListViewModelFactoring
    private let showEventDetailsService: ShowEventDetailsService
    private let createHappeningService: CreateHappeningService
    private let removeEventService: RemoveEventService
    private let showCreateEventService: ShowCreateEventService

    init(
        list: UICollectionView,
        viewModelProvider: EventsListViewModelFactoring,
        showEventDetailsService: ShowEventDetailsService,
        createHappeningService: CreateHappeningService,
        removeEventService: RemoveEventService,
        showCreateEventService: ShowCreateEventService
    ) {
        self.viewModelProvider = viewModelProvider
        self.showEventDetailsService = showEventDetailsService
        self.createHappeningService = createHappeningService
        self.removeEventService = removeEventService
        self.showCreateEventService = showCreateEventService

        let hintCellRegistration = UICollectionView.CellRegistration
        <HintCell, HintCellViewModel> { cell, _, viewModel in
            cell.viewModel = viewModel
        }
        let eventCellRegistration = UICollectionView.CellRegistration
        <EventCell, EventCellViewModel> { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = showEventDetailsService
            cell.swipeService = createHappeningService
            cell.removeService = removeEventService
        }
        let createEventCellRegistration = UICollectionView.CellRegistration
        <CreateEventCell, CreateEventCellViewModel> { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = showCreateEventService
        }

        dataSource = DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let item = viewModelProvider.makeEventsListViewModel().viewModel(forIdentifier: itemIdentifier) else { fatalError() }

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
        let viewModel = viewModelProvider.makeEventsListViewModel()
        guard
            viewModel.removalDropAreaHidden
        else { return }
        var snapshot = Snapshot()

        for section in EventsListViewModel.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(
                viewModel.identifiersFor(section: section),
                toSection: section
            )
            // TODO: optimize this solution
            snapshot.reconfigureItems(viewModel.identifiersFor(section: section))
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
