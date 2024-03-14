//
//  GoalsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Foundation
import UIKit

final class GoalsView: UIView, GoalsDataProviding {
    let list: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: GoalsView.makeLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var viewModel: GoalsViewModel? { didSet {
        dataSource.applySnapshot(oldValue)
        setNeedsLayout()
    }}

    lazy var heightConstraint: NSLayoutConstraint = { list.heightAnchor.constraint(equalToConstant: 7 * .layoutSquare) }()
    lazy var dataSource = GoalsDataSource(list: list, provider: WeakRef(self))

    init() {
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
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        list.backgroundColor = .clear
    }

    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let heightDimension: NSCollectionLayoutDimension = .estimated(3 * .layoutSquare)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let isCreateGoalSection = sectionIndex == GoalsViewModel.Section.createGoal.rawValue
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
