//
//  DayDetailsDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2024.
//

import UIKit

protocol DayDetailsDataProviding {
    var viewModel: DayDetailsViewModel? { get }
}

struct DayDetailsDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Registration = UICollectionView.CellRegistration<DayCell, DayCellViewModel>

    private let provider: DayDetailsDataProviding
    private var dataSource: DataSource?

    init(list: UICollectionView, provider: DayDetailsDataProviding) {
        self.provider = provider

        let registration = Registration { cell, _, viewModel in cell.viewModel = viewModel }

        dataSource = DataSource(collectionView: list) { collectionView, indexPath, itemIdentifier in
            if let item = provider.viewModel?.cell(for: itemIdentifier) {
                return collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: item
                )
            }
            return nil
        }
    }

    func applySnapshot(_ oldValue: DayDetailsViewModel?) {
        guard let viewModel = provider.viewModel else { return }
        var snapshot = Snapshot()

        let defaultSection = 0
        snapshot.appendSections([defaultSection])
        snapshot.appendItems(
            viewModel.identifiers,
            toSection: defaultSection
        )

        snapshot.reconfigureItems(viewModel.identifiers)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
