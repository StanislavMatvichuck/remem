//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

final class EventsListView: UIView {
    let list: UICollectionView
    let dataSource: EventsListDataSource
    
    lazy var removalDropArea = RemovalDropAreaView(handler: { [weak self] draggedCellIndex in
        if let cell = self?.list.cellForItem(at: IndexPath(row: draggedCellIndex, section: 1)) as? EventCell {
            cell.handleRemove()
        }
    })
    
    var viewModel: EventsListViewModel? { didSet {
        guard let viewModel else { return }
        removalDropArea.viewModel = viewModel.dragAndDrop
        dataSource.applySnapshot(oldValue)
    }}
    
    init(list: UICollectionView, dataSource: EventsListDataSource) {
        self.list = list
        self.dataSource = dataSource
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }
    
    // TODO: enable and test this behaviour
    func startHintAnimationIfNeeded() {
//        guard
//            let viewModel,
//            let eventsSection = viewModel.sections.first(where: { section in
//                section == .events
//            }),
//            viewModel.cellsIdentifiers(for: .events).count > 0
//        else { return }
//
//        let firstEventCellIndexPath = IndexPath(
//            row: 0,
//            section: eventsSection.rawValue
//        )
//
//        guard
//            let eventCell = list.cellForItem(
//                at: firstEventCellIndexPath
//            ) as? EventCell
//        else { return }
//
//        eventCell.view.hintDisplay.startAnimationIfNeeded()
    }
    
    static func makeList() -> UICollectionView {
        let list = UICollectionView(frame: .zero, collectionViewLayout: EventsListView.makeLayout())
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }
    
    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let heightDimension: NSCollectionLayoutDimension = .estimated(.eventsListCellHeight)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = .buttonMargin
            section.contentInsets = NSDirectionalEdgeInsets(
                top: .buttonMargin, leading: 0,
                bottom: .buttonMargin, trailing: 0
            )
            return section
        }
    }
    
    // MARK: - Private
    
    private func configureLayout() {
        addAndConstrain(list)
        addAndConstrain(removalDropArea)
    }
    
    private func configureAppearance() {
        list.backgroundColor = .clear
        backgroundColor = .remem_bg
    }
}
