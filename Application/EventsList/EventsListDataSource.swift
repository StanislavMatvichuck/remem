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

    private lazy var dataSource: DataSource = {
        let hintCellRegistration = UICollectionView.CellRegistration<HintCell, HintCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
        }
        let eventCellRegistration = UICollectionView.CellRegistration<EventCell, EventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = self.showEventDetailsService.makeShowEventDetailsService(id: viewModel.id)
            cell.swipeService = self.createHappeningService.makeCreateHappeningService(id: viewModel.id)
            cell.removeService = self.removeEventService.makeRemoveEventService(id: viewModel.id)
        }
        let createEventCellRegistration = UICollectionView.CellRegistration<CreateEventCell, CreateEventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = self.showCreateEventService
        }

        return DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            /// Called frequently. Have to cache viewModel somewhere
            ///     in a controller?
            /// But how to know that viewModel has to be updated? Controller knows and updates.
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
    }()

    weak var viewModelProvider: EventsListDataProviding?

    private let list: UICollectionView
    private let showEventDetailsService: ShowEventDetailsServiceFactoring
    private let createHappeningService: CreateHappeningServiceFactoring
    private let removeEventService: RemoveEventServiceFactoring
    private let showCreateEventService: ShowCreateEventService

    init(
        list: UICollectionView,
        showEventDetailsService: ShowEventDetailsServiceFactoring,
        createHappeningService: CreateHappeningServiceFactoring,
        removeEventService: RemoveEventServiceFactoring,
        showCreateEventService: ShowCreateEventService
    ) {
        self.list = list
        self.showEventDetailsService = showEventDetailsService
        self.createHappeningService = createHappeningService
        self.removeEventService = removeEventService
        self.showCreateEventService = showCreateEventService
    }

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
