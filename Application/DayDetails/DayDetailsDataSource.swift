//
//  DayDetailsDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2024.
//

import UIKit

final class DayDetailsDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DayCellViewModel.ID>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, DayCellViewModel.ID>
    typealias Registration = UICollectionView.CellRegistration<DayCell, DayCellViewModel>

    private let registration = Registration { cell, _, viewModel in cell.viewModel = viewModel }
    private let list: UICollectionView

    var viewModel: DayDetailsViewModel { didSet { applySnapshot() }}

    private lazy var dataSource: DataSource = {
        DataSource(collectionView: list) {
            [weak self] collectionView, indexPath, itemIdentifier in

            if
                let item = self?.viewModel.cell(for: itemIdentifier),
                let registration = self?.registration
            {
                return collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: item
                )
            }

            fatalError(collectionViewDataSourceError)
        }
    }()

    init(list: UICollectionView, viewModel: DayDetailsViewModel) {
        self.list = list
        self.viewModel = viewModel
    }

    func applySnapshot() {
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
