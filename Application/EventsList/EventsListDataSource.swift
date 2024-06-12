//
//  EventsListDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2023.
//

import UIKit

final class EventsListDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsListViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<EventsListViewModel.Section, String>

    private let list: UICollectionView
    private let showEventDetailsService: ShowEventDetailsService
    private let createHappeningService: CreateHappeningService
    private let removeEventService: RemoveEventService
    private let eventCellViewModelFactoryFactoring: EventCellViewModelFactoryFactoring
    private let showCreateEventService: ShowCreateEventService
    private let loadingHandler: LoadableViewModelHandling
    var viewModel: EventsListViewModel { didSet { applySnapshot() }}

    init(
        list: UICollectionView,
        showEventDetailsService: ShowEventDetailsService,
        createHappeningService: CreateHappeningService,
        removeEventService: RemoveEventService,
        showCreateEventService: ShowCreateEventService,
        eventCellViewModelFactory: @escaping EventCellViewModelFactoryFactoring,
        loadingHandler: LoadableViewModelHandling,
        viewModel: EventsListViewModel
    ) {
        self.list = list
        self.showEventDetailsService = showEventDetailsService
        self.createHappeningService = createHappeningService
        self.removeEventService = removeEventService
        self.showCreateEventService = showCreateEventService
        self.eventCellViewModelFactoryFactoring = eventCellViewModelFactory
        self.loadingHandler = loadingHandler
        self.viewModel = viewModel
    }

    private lazy var dataSource: DataSource = {
        let hintCellRegistration = UICollectionView.CellRegistration<HintCell, HintCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
        }

        let eventCellRegistration = UICollectionView.CellRegistration<EventCell, Loadable<EventCellViewModel>>
        { cell, _, viewModel in

            if cell.viewModel == nil {
                /// works for initial rendering
                cell.viewModel = viewModel
            }

            cell.configureServices(
                tapService: self.showEventDetailsService,
                swipeService: self.createHappeningService,
                removeService: self.removeEventService,
                loadingInterrupter: self.loadingHandler
            )
        }

        let createEventCellRegistration = UICollectionView.CellRegistration<CreateEventCell, CreateEventCellViewModel>
        { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.tapService = self.showCreateEventService
        }

        return DataSource(collectionView: list) { collectionView, indexPath, itemIdentifier in
            guard let cellViewModel = self.viewModel.viewModel(forIdentifier: itemIdentifier) else { fatalError() }

            let configuredCell: UICollectionViewCell = { switch indexPath.section {
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
                    item: cellViewModel as? Loadable<EventCellViewModel>
                )
            case EventsListViewModel.Section.createEvent.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: createEventCellRegistration,
                    for: indexPath,
                    item: cellViewModel as? CreateEventCellViewModel
                )
            default: fatalError()
            }
            }()

            if let loadableCell = configuredCell as? EventCell {
                let factory = self.eventCellViewModelFactoryFactoring(itemIdentifier)
                self.loadingHandler.load(for: loadableCell, factory: factory)
            }

            return configuredCell
        }
    }()

    func applySnapshot() {
        guard viewModel.dragAndDrop.removalDropAreaHidden else { return }

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
