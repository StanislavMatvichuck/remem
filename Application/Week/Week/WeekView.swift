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

    var viewModel: WeekViewModel? { didSet {
        guard let viewModel else { return }
        configureContentFor(viewModel)
    } }

    var service: ShowDayDetailsService?

    init(service: ShowDayDetailsService? = nil) {
        self.service = service
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addAndConstrain(collection)
    }

    private func configureAppearance() {
        backgroundColor = .remem_bg
        collection.backgroundColor = .clear
    }

    private func configureContentFor(_ viewModel: WeekViewModel) {
        collection.reloadData()
    }
}

extension WeekView: UICollectionViewDataSource {
    var viewModelErrorMessage: String { collectionViewDataSourceWeekError }

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
        page.service = service
        page.viewModel = viewModel.page(at: indexPath.row)
        return page
    }
}

extension WeekView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width)
    }
}
