//
//  GoalsDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import UIKit

protocol UpdateGoalServiceFactoring { func makeUpdateGoalService(goalId: String) -> UpdateGoalService }

final class GoalsDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<GoalsViewModel.Section, String>
    typealias DataSource = UICollectionViewDiffableDataSource<GoalsViewModel.Section, String>

    private let list: UICollectionView
    var viewModel: GoalsViewModel { didSet { applySnapshot() }}

    private let goalCellRegistration = UICollectionView.CellRegistration<GoalCell, GoalViewModel> { cell, _, viewModel in
        cell.viewModel = viewModel
    }

    private let createGoalCellRegistration = UICollectionView.CellRegistration<CreateGoalCell, CreateGoalViewModel> { cell, _, viewModel in
        cell.viewModel = viewModel
    }

    private lazy var dataSource: DataSource = { DataSource(collectionView: self.list) {
        [weak self] collectionView, indexPath, itemIdentifier in

        guard
            let item = self?.viewModel.cell(identifier: itemIdentifier),
            let goalCellRegistration = self?.goalCellRegistration,
            let createGoalCellRegistration = self?.createGoalCellRegistration
        else { fatalError() }

        switch indexPath.section {
        case GoalsViewModel.Section.goals.rawValue:
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: goalCellRegistration,
                for: indexPath,
                item: item as? GoalViewModel
            )
            cell.deleteService = self?.deleteGoalService
            cell.input.updateService = self?.updateServiceFactory.makeUpdateGoalService(goalId: item.id)
            return cell
        case GoalsViewModel.Section.createGoal.rawValue:
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: createGoalCellRegistration,
                for: indexPath,
                item: item as? CreateGoalViewModel
            )

            cell.service = self?.createGoalService
            return cell
        default: fatalError()
        }
    } }()

    private let createGoalService: CreateGoalService
    private let deleteGoalService: DeleteGoalService
    private let updateServiceFactory: UpdateGoalServiceFactoring

    init(
        list: UICollectionView,
        viewModel: GoalsViewModel,
        createGoalService: CreateGoalService,
        deleteGoalService: DeleteGoalService,
        updateServiceFactory: UpdateGoalServiceFactoring
    ) {
        self.list = list
        self.viewModel = viewModel
        self.createGoalService = createGoalService
        self.deleteGoalService = deleteGoalService
        self.updateServiceFactory = updateServiceFactory
    }

    func applySnapshot() {
        guard viewModel.dragAndDrop.removalDropAreaHidden else { return }

        var snapshot = Snapshot()

        for section in viewModel.sections {
            snapshot.appendSections([section])
            let identifiers = viewModel.cellsIdentifiers(for: section)
            snapshot.appendItems(identifiers, toSection: section)
            snapshot.reconfigureItems(identifiers)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
