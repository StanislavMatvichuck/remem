//
//  SummaryViewDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.02.2024.
//

import UIKit

final class SummaryDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SummaryRow>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SummaryRow>

    let list: UICollectionView
    var viewModel: Loadable<SummaryViewModel> { didSet { applySnapshot() }}

    private lazy var dataSource: DataSource = {
        let createEventCellRegistration = UICollectionView.CellRegistration<SummaryCell, SummaryCellViewModel> { cell, _, viewModel in cell.viewModel = viewModel }

        return DataSource(collectionView: list) {
            [weak self] collectionView, indexPath, itemIdentifier in

            guard let item = self?.viewModel.vm?.cell(for: itemIdentifier) else { fatalError() }

            return collectionView.dequeueConfiguredReusableCell(
                using: createEventCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }()

    init(list: UICollectionView, viewModel: Loadable<SummaryViewModel>) {
        self.list = list
        self.viewModel = viewModel
    }

    func applySnapshot() {
        guard let viewModel = viewModel.vm else { return }
        var snapshot = Snapshot()

        let defaultSection = 0
        snapshot.appendSections([defaultSection])
        snapshot.appendItems(
            viewModel.identifiers,
            toSection: defaultSection
        )

        snapshot.reconfigureItems(viewModel.identifiers)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
