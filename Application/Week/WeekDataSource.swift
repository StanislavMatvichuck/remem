//
//  WeekDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 15.06.2024.
//

import UIKit

final class WeekDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<WeekViewModel.Section, Int>
    typealias DataSource = UICollectionViewDiffableDataSource<WeekViewModel.Section, Int>

    private let list: UICollectionView
    private let showDayDetailsService: ShowDayDetailsService
    var viewModel: Loadable<WeekViewModel> { didSet { applySnapshot() }}

    init(
        list: UICollectionView,
        viewModel: Loadable<WeekViewModel>,
        showDayDetailsService: ShowDayDetailsService
    ) {
        self.list = list
        self.viewModel = viewModel
        self.showDayDetailsService = showDayDetailsService
    }

    private let registration = UICollectionView.CellRegistration<WeekPageView, WeekPageViewModel> { cell, _, viewModel in cell.viewModel = viewModel }

    private lazy var dataSource: DataSource = {
        DataSource(collectionView: list) {
            [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let item = self?.viewModel.vm?.viewModel(forIdentifier: itemIdentifier),
                let registration = self?.registration,
                let showDayDetailsService = self?.showDayDetailsService
            else { fatalError(collectionViewDataSource) }

            let configuredCell = collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )

            configuredCell.configureServices(showDayDetails: showDayDetailsService)

            return configuredCell
        }
    }()

    func applySnapshot() {
        var snapshot = Snapshot()

        for section in WeekViewModel.Section.allCases {
            guard let identifiers = viewModel.vm?.identifiersFor(section: section) else { return }
            snapshot.appendSections([section])
            snapshot.appendItems(identifiers, toSection: section)
            // TODO: optimize this solution
            snapshot.reconfigureItems(identifiers)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
        scrollToLastPage()
    }

    private func scrollToLastPage() {
        guard let viewModel = viewModel.vm else { return }
        let lastPageIndex = IndexPath(row: viewModel.pagesCount - 1, section: 0)
        list.scrollToItem(at: lastPageIndex, at: .right, animated: false)
    }
}
