//
//  NewWeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import UIKit

final class NewWeekView: UIView {
    let collection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 0.0
        collectionLayout.minimumLineSpacing = 0.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.register(NewWeekPageView.self, forCellWithReuseIdentifier: NewWeekPageView.reuseIdentifier)
        return collection
    }()

    var viewModel: NewWeekViewModel? {
        didSet {
            guard let viewModel else { return }
            configureContentFor(viewModel)
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        collection.dataSource = self
        collection.delegate = self
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addAndConstrain(collection)
    }

    private func configureAppearance() {
        backgroundColor = .bg
        collection.backgroundColor = .clear
    }

    private func configureContentFor(_ viewModel: NewWeekViewModel) {
        collection.reloadData()
    }
}

extension NewWeekView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            withReuseIdentifier: NewWeekPageView.reuseIdentifier,
            for: indexPath) as? NewWeekPageView, let viewModel
        else { fatalError(viewModelErrorMessage) }
        page.viewModel = viewModel.page(at: indexPath.row)
        return page
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width)
    }
}
