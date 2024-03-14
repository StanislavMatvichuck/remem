//
//  StatsView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryView: UIView, SummaryDataProviding {
    let list: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = .buttonMargin
        layout.minimumInteritemSpacing = .buttonMargin
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var viewModel: SummaryViewModel? { didSet {
        dataSource.applySnapshot(oldValue)
    }}

    lazy var dataSource = SummaryViewDiffableDataSource(list: list, provider: WeakRef(self))
    lazy var heightConstraint: NSLayoutConstraint = list.heightAnchor.constraint(equalToConstant: 4 * .layoutSquare + .buttonMargin) 

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        list.delegate = self
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addAndConstrain(list, constant: .buttonMargin)
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        list.backgroundColor = .clear
    }
}

extension SummaryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - .buttonMargin
        let cellWidth = (availableWidth / 2).rounded(.down)
        let cellHeight = 2 * collectionView.bounds.width / 7
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
