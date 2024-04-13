//
//  GoalsDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import UIKit

struct GoalsDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<GoalsViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<GoalsViewModel.Section, String>

    private let provider: GoalsViewModelFactoring
    private let dataSource: DataSource
    private let createGoalService: CreateGoalService

    init(list: UICollectionView, provider: GoalsViewModelFactoring, createGoalService: CreateGoalService) {
        self.createGoalService = createGoalService

        let goalCellRegistration = UICollectionView.CellRegistration<GoalCell, GoalViewModel> { cell, _, viewModel in
            cell.viewModel = viewModel
        }

        let createGoalCellRegistration = UICollectionView.CellRegistration<CreateGoalCell, CreateGoalViewModel> { cell, _, viewModel in
            cell.viewModel = viewModel
            cell.service = createGoalService
        }

        self.provider = provider
        dataSource = DataSource(collectionView: list) {
            collectionView, indexPath, itemIdentifier in

            guard let item = provider.makeGoalsViewModel().cell(identifier: itemIdentifier) else { fatalError() }

            switch indexPath.section {
            case GoalsViewModel.Section.goals.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: goalCellRegistration,
                    for: indexPath,
                    item: item as? GoalViewModel
                )
            case GoalsViewModel.Section.createGoal.rawValue:
                return collectionView.dequeueConfiguredReusableCell(
                    using: createGoalCellRegistration,
                    for: indexPath,
                    item: item as? CreateGoalViewModel
                )
            default: fatalError()
            }
        }
    }

    func applySnapshot(_ oldValue: GoalsViewModel?) {
        let viewModel = provider.makeGoalsViewModel()
        var snapshot = Snapshot()

        for section in viewModel.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(
                viewModel.cellsIdentifiers(for: section),
                toSection: section
            )
        }

        if let oldValue {
            let reconfiguredIdentifiers = viewModel.cellsRequireReconfigurationIds(oldValue: oldValue)
            snapshot.reconfigureItems(reconfiguredIdentifiers)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
