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
        guard let viewModel else { return }
        dataSource.applySnapshot(oldValue)
    }}

    lazy var dataSource = SummaryViewDiffableDataSource(list: list, provider: self)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addAndConstrain(list, constant: .buttonMargin)
        list.heightAnchor.constraint(equalToConstant: 4 * .layoutSquare + .buttonMargin).isActive = true
    }

    private func configureAppearance() {
        list.backgroundColor = .clear
    }
}
