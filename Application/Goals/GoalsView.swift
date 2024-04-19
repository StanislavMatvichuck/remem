//
//  GoalsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Foundation
import UIKit

final class GoalsView: UIView {
    let list: UICollectionView
    let dataSource: GoalsDataSource
    lazy var removalDropArea = RemovalDropAreaView(handler: { [weak self] draggedCellIndex in
        if let cell = self?.list.cellForItem(at: IndexPath(row: draggedCellIndex, section: 0)) as? GoalCell,
           let id = cell.viewModel?.id
        {
            cell.deleteService?.serve(DeleteGoalServiceArgument(goalId: id))
        }
    })

    var viewModel: GoalsViewModel? { didSet {
        removalDropArea.viewModel = viewModel?.dragAndDrop
        dataSource.applySnapshot(oldValue)
        setNeedsLayout()
    }}

    lazy var heightConstraint: NSLayoutConstraint = { list.heightAnchor.constraint(equalToConstant: 7 * .layoutSquare) }()

    init(list: UICollectionView, dataSource: GoalsDataSource) {
        self.list = list
        self.dataSource = dataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        list.layoutIfNeeded()
        heightConstraint.constant = list.contentSize.height
    }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(list)
        addAndConstrain(removalDropArea)
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        list.backgroundColor = .clear
    }

    static func makeList() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: GoalsView.makeLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let isCreateGoalSection = sectionIndex == GoalsViewModel.Section.createGoal.rawValue
            let height = NSCollectionLayoutDimension.fractionalWidth(isCreateGoalSection ? 0.2 : 1.0)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = .buttonMargin
            section.contentInsets = NSDirectionalEdgeInsets(
                top: isCreateGoalSection ? 0 : .buttonMargin, leading: .buttonMargin,
                bottom: .buttonMargin, trailing: .buttonMargin
            )
            return section
        }
    }
}
