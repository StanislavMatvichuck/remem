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
protocol EventsListDataProviding: AnyObject { var viewModel: EventsListViewModel? { get } }

final class EventsListDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<EventsListViewModel.Section, String>

    weak var viewModelProvider: EventsListDataProviding?

    private let list: UICollectionView
    private let showEventDetailsServiceFactory: ShowEventDetailsServiceFactoring
    private let createHappeningServiceFactory: CreateHappeningServiceFactoring
    private let removeEventServiceFactory: RemoveEventServiceFactoring
    private let eventCellViewModelFactory: LoadableEventCellViewModelFactoring
    private let showCreateEventService: ShowCreateEventService
    private let cellsLoadingManager = CellsLoadingManager()

    init(
        list: UICollectionView,
        showEventDetailsServiceFactory: ShowEventDetailsServiceFactoring,
        createHappeningServiceFactory: CreateHappeningServiceFactoring,
        removeEventServiceFactory: RemoveEventServiceFactoring,
        showCreateEventService: ShowCreateEventService,
        eventCellViewModelFactory: LoadableEventCellViewModelFactoring
    ) {
        self.list = list
        self.showEventDetailsServiceFactory = showEventDetailsServiceFactory
        self.createHappeningServiceFactory = createHappeningServiceFactory
        self.removeEventServiceFactory = removeEventServiceFactory
        self.showCreateEventService = showCreateEventService
        self.eventCellViewModelFactory = eventCellViewModelFactory
    }

    private lazy var dataSource: DataSource = {
        let hintCellRegistration = UICollectionView.CellRegistration<HintCell, HintCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
        }

        let eventCellRegistration = UICollectionView.CellRegistration<EventCell, LoadableEventCellViewModel>
        { cell, _, viewModel in

            if cell.viewModel == nil {
                /// works for initial rendering
                cell.viewModel = viewModel
            }

            if let eventId = viewModel.loadingArguments {
                cell.configureServices(
                    tapService: self.showEventDetailsServiceFactory.makeShowEventDetailsService(id: eventId),
                    swipeService: self.createHappeningServiceFactory.makeCreateHappeningService(id: eventId),
                    removeService: self.removeEventServiceFactory.makeRemoveEventService(id: eventId),
                    loadingInterrupter: self.cellsLoadingManager
                )
                self.cellsLoadingManager.startLoading(for: cell, factory: self.eventCellViewModelFactory) // assigns loaded vm
            }
        }

        let createEventCellRegistration = UICollectionView.CellRegistration<CreateEventCell, CreateEventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = self.showCreateEventService
        }

        return DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let cellViewModel = self.viewModelProvider?.viewModel?.viewModel(forIdentifier: itemIdentifier) else { fatalError() }

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
                    item: cellViewModel as? LoadableEventCellViewModel
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
    }()

    func applySnapshot(_ oldValue: EventsListViewModel?) {
        guard let viewModel = viewModelProvider?.viewModel,
              viewModel.dragAndDrop.removalDropAreaHidden
        else { return }

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
