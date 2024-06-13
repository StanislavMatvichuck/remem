//
//  StatsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryView: UIView, LoadableView, UsingLoadableViewModel {
    let list: UICollectionView

    var viewModel: Loadable<SummaryViewModel>? { didSet {
        if viewModel?.loading == true {
            displayLoading()
        } else {
            disableLoadingCover()
        }
    }}

    lazy var heightConstraint: NSLayoutConstraint = list.heightAnchor.constraint(equalToConstant: 4 * .layoutSquare + .buttonMargin)

    init(list: UICollectionView) {
        self.list = list
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Public

    static func makeList() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    // MARK: - Private

    private func configureLayout() {
        addAndConstrain(list, constant: .buttonMargin)
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        list.backgroundColor = .clear
    }

    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let heightDimension: NSCollectionLayoutDimension = .absolute(2 * CGFloat.layoutSquare)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(.buttonMargin)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = .buttonMargin
            return section
        }
    }
}
