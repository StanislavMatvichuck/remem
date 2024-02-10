//
//  DayDetailsDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.02.2024.
//

import UIKit

final class DayDetailsDataSource: UICollectionViewDiffableDataSource<Int, DayCellViewModel> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DayCellViewModel>

    var viewModel: DayDetailsViewModel? { didSet {
        guard let viewModel else { return }
        apply(makeSnapshot(for: viewModel), animatingDifferences: true, completion: nil)
    }}

    init(_ collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellProvider: Self.Provider)
    }

    static let Provider: UICollectionViewDiffableDataSourceReferenceCellProvider = {
        table, indexPath, cellViewModel in
        guard let cell = table.dequeueReusableCell(
            withReuseIdentifier: DayCell.reuseIdentifier,
            for: indexPath
        ) as? DayCell,
            let viewModel = cellViewModel as? DayCellViewModel
        else { fatalError() }
        cell.viewModel = viewModel
        return cell
    }

    private func makeSnapshot(for vm: DayDetailsViewModel) -> Snapshot {
        var snapshot = Snapshot()

        snapshot.appendSections([0])

        snapshot.appendItems(vm.cells, toSection: 0)

        /// Allows animation for same cells N times
//        if let eventCells = vm.cells(for: .events) as? [EventCellViewModel] {
//            let animatedEventCells = eventCells.filter { $0.animation != .none }
//            snapshot.reloadItems(animatedEventCells)
//        }

        return snapshot
    }
}
