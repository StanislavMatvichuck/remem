//
//  SummaryViewDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.02.2024.
//

import UIKit

protocol SummaryDataProviding {
    var viewModel: SummaryViewModel? { get }
}

struct SummaryViewDiffableDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SummaryRow>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SummaryRow>

    private let provider: SummaryDataProviding
    private let dataSource: DataSource

    init(list: UICollectionView, provider: SummaryDataProviding) {
        let createEventCellRegistration = UICollectionView.CellRegistration<SummaryCell, SummaryCellViewModel> { cell, _, viewModel in cell.viewModel = viewModel }

        self.provider = provider
        dataSource = DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let item = provider.viewModel?.cell(for: itemIdentifier) else { fatalError() }

            return collectionView.dequeueConfiguredReusableCell(
                using: createEventCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    func applySnapshot(_ oldValue: SummaryViewModel?) {
        guard let viewModel = provider.viewModel else { return }
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
