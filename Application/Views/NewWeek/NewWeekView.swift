//
//  WeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import UIKit

final class WeekView: UIView {
    let collection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 0.0
        collectionLayout.minimumLineSpacing = 0.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.register(WeekPageView.self, forCellWithReuseIdentifier: WeekPageView.reuseIdentifier)
        return collection
    }()

    var viewModel: WeekViewModel? {
        didSet {
            guard let viewModel else { return }
            configureContentFor(viewModel)
        }
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addAndConstrain(collection)
    }

    private func configureAppearance() {
        backgroundColor = .bg
        collection.backgroundColor = .clear
    }

    private func configureContentFor(_ viewModel: WeekViewModel) {
        collection.reloadData()
    }
}

extension WeekView: UICollectionViewDataSource {
    var viewModelErrorMessage: String { "view has no access to viewModel" }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        guard let viewModel else { fatalError(viewModelErrorMessage) }
        return viewModel.pagesCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let page = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeekPageView.reuseIdentifier,
            for: indexPath) as? WeekPageView, let viewModel
        else { fatalError(viewModelErrorMessage) }
        page.viewModel = viewModel.page(at: indexPath.row)
        return page
    }
}
