//
//  WeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import UIKit

final class WeekView: UIView, LoadableView {
    let list: UICollectionView

    static func makeList() -> UICollectionView {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: WeekView.makeLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        return collection
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        return layout
    }

    var viewModel: Loadable<WeekViewModel> { didSet { configureContent() } }
    var service: ShowDayDetailsService?

    init(list: UICollectionView, viewModel: Loadable<WeekViewModel>, service: ShowDayDetailsService? = nil) {
        self.service = service
        self.list = list
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configureContent()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addAndConstrain(list)
    }

    private func configureAppearance() {
        backgroundColor = .remem_bg
        list.backgroundColor = .clear
    }

    private func configureContent() {
        if viewModel.loading == true {
            displayLoading()
        } else {
            disableLoadingCover()
        }
    }
}
